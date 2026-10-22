/*
 * sim.c
 *
 * C rewrite of sim.tcl: discrete-event simulation of the
 * search.swift workload (Algorithm 1 in evaluate.tcl), using
 * c-utils data structures (a min-heap and dynamic int arrays)
 * instead of Tcl lists, for speed.
 *
 * This is a reimplementation, not a literal port, in two ways:
 *
 *  - Task durations come from drand48()/srand48(), not Tcl's
 *    rand()/srand().  A given -seed is reproducible within this
 *    program, but will not reproduce the same numbers as sim.tcl.
 *
 *  - evaluate.tcl is not re-sourced.  Its one active algorithm
 *    (Algorithm 1) is reimplemented directly below: the children
 *    of task (i,c) are always the contiguous range c..M-1, so they
 *    can be reconstructed from (i,c) and the global M without ever
 *    storing a child list.
 *
 * Usage: see usage() below, or run with -h.
 */

#include <inttypes.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <dyn_array_i.h>

/* events: tasks in flight, a min-heap keyed on (end_time_ms, seq).
 * seq is a strictly increasing insertion counter, packed into the
 * low bits of the key, that breaks exact end_time ties in start
 * order (task durations are independent random draws, so end_time
 * is not monotonic with start order; see Transcript-sim.adoc for
 * why this tie-break matters for -seed reproducibility). */
#define HEAP_KEY_T int64_t
#define HEAP_VAL_T int64_t
#define HEAP_PFX   evh_
#include <heap-template.h>

// --------------------------------------------------------- usage

static void
usage(void)
{
  printf("Usage:\n");
  printf("  sim [-m M] [-workers N] [-seed S] [-o FILE]\n");
  printf("      [-progress N] [-sample SECONDS]\n");
  printf("\n");
  printf("  -m        recursion/fanout limit, as passed to "
         "search.swift\n");
  printf("            (default 3)\n");
  printf("  -workers  concurrent tasks allowed; 0 means "
         "unlimited, which\n");
  printf("            shows the parallelism the workflow itself "
         "offers\n");
  printf("            (default 0)\n");
  printf("  -seed     RNG seed, for a reproducible run "
         "(default 1)\n");
  printf("  -o        output data file (default sim.data)\n");
  printf("  -progress report progress every N completed tasks; "
         "0 to\n");
  printf("            disable (default 1000).  Goes to stderr, "
         "so\n");
  printf("            stdout stays clean.\n");
  printf("  -sample   write -o at most one line per this many "
         "simulated\n");
  printf("            seconds, instead of one line per "
         "concurrency\n");
  printf("            change; 0 disables downsampling "
         "(default 0)\n");
  printf("  -h        print this help and exit\n");
}

// ----------------------------------------------------- arguments

struct options
{
  int    m;
  long   workers;
  long   seed;
  char  *o;
  long   progress;
  double sample;
};

static bool
parse_long(const char *s, long *out)
{
  char *end;
  *out = strtol(s, &end, 10);
  return end != s && *end == '\0';
}

static bool
parse_double(const char *s, double *out)
{
  char *end;
  *out = strtod(s, &end);
  return end != s && *end == '\0';
}

static void
parse_args(int argc, char **argv, struct options *opt)
{
  opt->m        = 3;
  opt->workers  = 0;
  opt->seed     = 1;
  opt->o        = "sim.data";
  opt->progress = 1000;
  opt->sample   = 0.0;

  for (int i = 1; i < argc; i++)
  {
    if (strcmp(argv[i], "-h") == 0 ||
        strcmp(argv[i], "--help") == 0)
    {
      usage();
      exit(0);
    }
  }

  for (int i = 1; i < argc; i += 2)
  {
    const char *flag = argv[i];
    if (i + 1 >= argc)
    {
      fprintf(stderr, "sim: missing value for option: %s\n", flag);
      exit(1);
    }
    const char *value = argv[i + 1];
    long l;
    double d;

    if (strcmp(flag, "-m") == 0 && parse_long(value, &l))
    {
      opt->m = (int) l;
    }
    else if (strcmp(flag, "-workers") == 0 && parse_long(value, &l))
    {
      opt->workers = l;
    }
    else if (strcmp(flag, "-seed") == 0 && parse_long(value, &l))
    {
      opt->seed = l;
    }
    else if (strcmp(flag, "-o") == 0)
    {
      opt->o = (char *) value;
    }
    else if (strcmp(flag, "-progress") == 0 && parse_long(value, &l))
    {
      opt->progress = l;
    }
    else if (strcmp(flag, "-sample") == 0 && parse_double(value, &d))
    {
      opt->sample = d;
    }
    else
    {
      fprintf(stderr, "sim: unknown option or bad value: "
              "%s %s\n", flag, value);
      exit(1);
    }
  }
}

// --------------------------------------------------- ready queue
//
// ready: tasks waiting to start.  Every entry gets ready_time_ms
// equal to the simulation clock at the moment it is pushed, and the
// clock only moves forward, so the queue is already non-decreasing
// in ready_time_ms by construction (see Transcript-sim.adoc).  A
// FIFO over three parallel dyn_array_i arrays, with a read pointer
// that is advanced on pop and periodically compacted, gives O(1)
// amortized push/pop with no per-entry allocation.

struct ready_queue {
  struct dyn_array_i t; // ready_time_ms
  struct dyn_array_i i; // task depth
  struct dyn_array_i c; // task's c parameter
  size_t head;
};

static void
rq_init(struct ready_queue *q)
{
  dyn_array_i_init(&q->t, 1024);
  dyn_array_i_init(&q->i, 1024);
  dyn_array_i_init(&q->c, 1024);
  q->head = 0;
}

static void
rq_push(struct ready_queue *q, int t_ms, int i, int c)
{
  dyn_array_i_add(&q->t, t_ms);
  dyn_array_i_add(&q->i, i);
  dyn_array_i_add(&q->c, c);
}

static size_t
rq_size(struct ready_queue *q)
{
  return q->t.size - q->head;
}

// Ready time of the front entry, or -1 if empty.
static int
rq_peek_time(struct ready_queue *q)
{
  if (q->head >= q->t.size) return -1;
  return q->t.arr[q->head];
}

static void
rq_pop(struct ready_queue *q, int *t_ms, int *i, int *c)
{
  *t_ms = q->t.arr[q->head];
  *i    = q->i.arr[q->head];
  *c    = q->c.arr[q->head];
  q->head++;

  // Periodically drop the consumed prefix so the arrays don't grow
  // without bound over a long run.
  if (q->head > 1024 && q->head * 2 > q->t.size)
  {
    size_t n = q->t.size - q->head;
    memmove(q->t.arr, q->t.arr + q->head, n * sizeof(int));
    memmove(q->i.arr, q->i.arr + q->head, n * sizeof(int));
    memmove(q->c.arr, q->c.arr + q->head, n * sizeof(int));
    q->t.size = q->i.size = q->c.size = n;
    q->head = 0;
  }
}

// Next ready_time_ms strictly after now_ms, or -1 if none.  The
// queue is sorted by construction, so this scans past any entries
// left at or before now_ms -- which only happens when a -workers
// cap stopped the start loop from draining them -- and stops at the
// first one past it.
static int
rq_min_ready_after(struct ready_queue *q, int now_ms)
{
  for (size_t k = q->head; k < q->t.size; k++)
  {
    if (q->t.arr[k] > now_ms) return q->t.arr[k];
  }
  return -1;
}

// --------------------------------------------------------- samples

struct samples {
  struct dyn_array_i t; // time_ms
  struct dyn_array_i n; // concurrency level
};

static void
samples_init(struct samples *s)
{
  dyn_array_i_init(&s->t, 1024);
  dyn_array_i_init(&s->n, 1024);
}

// Record a change in concurrency as two points, so a plot of this
// series steps rather than sloping between events.
static void
samples_record(struct samples *s, int t_ms, int before, int after)
{
  dyn_array_i_add(&s->t, t_ms);
  dyn_array_i_add(&s->n, before);
  dyn_array_i_add(&s->t, t_ms);
  dyn_array_i_add(&s->n, after);
}

// --------------------------------------------------------- events
//
// events: tasks in flight.  Keyed on (end_time_ms, seq): end_time
// is not monotonic with start order (each task's duration is an
// independent random draw), so this is a genuine heap, not a queue.

static int64_t
evh_key(int end_ms, int64_t seq)
{
  return ((int64_t) end_ms << 32) | (uint32_t) seq;
}

static int
evh_key_end_ms(int64_t key)
{
  return (int) (key >> 32);
}

static int64_t
evh_val_pack(int i, int c)
{
  return ((int64_t) i << 32) | (uint32_t) c;
}

static void
evh_val_unpack(int64_t val, int *i, int *c)
{
  *i = (int) (val >> 32);
  *c = (int) (uint32_t) val;
}

// ----------------------------------------------------------- main

int
main(int argc, char **argv)
{
  struct options opt;
  parse_args(argc, argv, &opt);

  int  M        = opt.m;
  long WORKERS  = opt.workers;
  long PROGRESS = opt.progress;

  srand48(opt.seed);

  struct timespec wall_start;
  clock_gettime(CLOCK_MONOTONIC, &wall_start);

  struct ready_queue ready;
  rq_init(&ready);

  evh_t events;
  evh_init(&events, 1024);
  int64_t seq = 0;

  struct samples samples;
  samples_init(&samples);

  int  now       = 0;    // simulated ms
  int  running   = 0;
  long started   = 0;
  long completed = 0;

  rq_push(&ready, 0, 1, 0); // the root is search(1,0)

  while (rq_size(&ready) > 0 || evh_size(&events) > 0)
  {
    // Start every ready task we have capacity for
    while (1)
    {
      if (WORKERS > 0 && running >= WORKERS) break;
      int rt = rq_peek_time(&ready);
      if (rt < 0 || rt > now) break;

      int t_ms, i, c;
      rq_pop(&ready, &t_ms, &i, &c);
      (void) t_ms;

      int delay_ms = (i <= 1) ?
        0 : (int) lround(drand48() * 20.0 * 1000.0);

      samples_record(&samples, now, running, running + 1);
      running++;
      started++;

      int64_t key = evh_key(now + delay_ms, seq++);
      evh_add(&events, key, evh_val_pack(i, c));
    }

    if (evh_size(&events) == 0)
    {
      // Nothing in flight: jump to the next task that becomes ready
      int t = rq_min_ready_after(&ready, now);
      if (t < 0) break;
      now = t;
      continue;
    }

    // Advance to the next completion, or to the next task becoming
    // ready if that happens first
    int t_end   = evh_key_end_ms(evh_root_key(&events));
    int t_ready = rq_min_ready_after(&ready, now);
    if (t_ready >= 0 && t_ready < t_end)
    {
      now = t_ready;
      continue;
    }
    now = t_end;

    // Retire everything finishing now, releasing their children
    while (evh_size(&events) > 0 &&
           evh_key_end_ms(evh_root_key(&events)) <= now)
    {
      int64_t val = evh_root_val(&events);
      evh_del_root(&events);

      int i, c;
      evh_val_unpack(val, &i, &c);

      samples_record(&samples, now, running, running - 1);
      running--;
      completed++;

      if (PROGRESS > 0 && completed % PROGRESS == 0)
      {
        fprintf(stderr,
                "sim: %ld tasks done, t=%.1fs, %d running, "
                "%zu ready\n",
                completed, now / 1000.0, running, rq_size(&ready));
        fflush(stderr);
      }

      if (i < M)
      {
        for (int j = c; j < M; j++)
        {
          rq_push(&ready, now, i + 1, j);
        }
      }
    }
  }

  // ------------------------------------------------------- output

  int    peak   = 0;
  double area   = 0.0; // concurrent * ms
  int    prev_t = 0;
  int    prev_n = 0;
  for (size_t k = 0; k < samples.t.size; k++)
  {
    int t = samples.t.arr[k];
    int n = samples.n.arr[k];
    if (n > peak) peak = n;
    area += (double) prev_n * (t - prev_t);
    prev_t = t;
    prev_n = n;
  }
  int makespan_ms = now;

  FILE *fd = fopen(opt.o, "w");
  if (fd == NULL)
  {
    fprintf(stderr, "sim: could not open for writing: %s\n", opt.o);
    exit(1);
  }

  char last[64] = "";
  char line[64];

  if (opt.sample <= 0.0)
  {
    // One line per concurrency change.  Several events can land on
    // the same instant, so drop points that repeat the previous
    // one: they add nothing to a step plot.
    for (size_t k = 0; k < samples.t.size; k++)
    {
      snprintf(line, sizeof(line), "%.3f\t%d",
                samples.t.arr[k] / 1000.0, samples.n.arr[k]);
      if (strcmp(line, last) != 0)
      {
        fprintf(fd, "%s\n", line);
        strcpy(last, line);
      }
    }
  }
  else
  {
    // One line per -sample seconds of simulated time, holding the
    // concurrency level in effect at each sampled instant.
    long long dt_ms = llround(opt.sample * 1000.0);
    if (dt_ms < 1) dt_ms = 1;
    size_t idx     = 0;
    int    cur_n   = 0;
    for (long long t = 0; t <= makespan_ms; t += dt_ms)
    {
      while (idx < samples.t.size && samples.t.arr[idx] <= t)
      {
        cur_n = samples.n.arr[idx];
        idx++;
      }
      snprintf(line, sizeof(line), "%.3f\t%d", t / 1000.0, cur_n);
      if (strcmp(line, last) != 0)
      {
        fprintf(fd, "%s\n", line);
        strcpy(last, line);
      }
    }
  }

  // Close the series off at the end of the workflow
  snprintf(line, sizeof(line), "%.3f\t%d", makespan_ms / 1000.0, 0);
  if (strcmp(line, last) != 0) fprintf(fd, "%s\n", line);

  fclose(fd);

  double makespan_s = makespan_ms / 1000.0;

  printf("M:        %d\n", M);
  if (WORKERS == 0)
  {
    printf("WORKERS:  unlimited\n");
  }
  else
  {
    printf("WORKERS:  %ld\n", WORKERS);
  }
  printf("TASKS:    %ld\n", started);
  printf("MAKESPAN: %.3f s\n", makespan_s);
  printf("PEAK:     %d concurrent\n", peak);
  if (makespan_s > 0)
  {
    printf("MEAN:     %.2f concurrent\n", area / 1000.0 / makespan_s);
    printf("RATE:     %.2f tasks/s\n", started / makespan_s);
  }

  struct timespec wall_end;
  clock_gettime(CLOCK_MONOTONIC, &wall_end);
  double wall_s = (wall_end.tv_sec - wall_start.tv_sec) +
    (wall_end.tv_nsec - wall_start.tv_nsec) / 1.0e9;
  if (wall_s > 0)
  {
    printf("TCL:      %.2f tasks/s (real wall time)\n",
           started / wall_s);
  }

  printf("wrote: %s\n", opt.o);

  return 0;
}
