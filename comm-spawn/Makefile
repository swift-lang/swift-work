
LDFLAGS :=

PROGRAMS := comm-spawn.x child.x

ifeq (${CRAY},1)
	LDFLAGS  += -craympich-dpm
	PROGRAMS += rankpool.x
endif

all: $(PROGRAMS)

comm-spawn.x: main.c
	$(CC) $(LDFLAGS) -o $(@) $(<)

child.x: child.c
	$(CC) $(LDFLAGS) -o $(@) $(<)

rankpool.x: rankpool.c
	$(CC) $(LDFLAGS) -o $(@) $(<)

clean:
	rm -fv *.x *.o
