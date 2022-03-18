import files;
import io;
import python;
import string;
import unix;

string command = 
"""
import os
import pathlib
import socket
import subprocess
import time

this_dir = pathlib.Path("/scratch/snx3000/rferreir/benchmarks/epigenomics-50000-100-cpu").absolute()

task_name = "%s"
print(f"[WfBench] [{task_name}] Starting Benchmark on {socket.gethostname()}")

print(f"[WfBench] [{task_name}] Starting IO Read Benchmark...")
files_list = "%s"
if "__" not in files_list:
    with open(this_dir.joinpath(files_list), "rb") as fp:
        start = time.perf_counter()
        print(f"[WfBench]   Reading '{files_list}'")
        fp.readlines()
        end = time.perf_counter()
        print(f"[WfBench] [{task_name}] Metrics (read) [time,size]: {end - start},{this_dir.joinpath(files_list).stat().st_size}")
else:
    files = files_list.split(", ")
    for file in files:
        counter = 0
        fd = file.split("__")
        start = time.perf_counter()
        file_size = 0
        for f in this_dir.glob(f"{fd[0]}_*_output.txt"):
            if counter >= int(fd[1]):
                break
            file_size += os.stat(f).st_size
            with open(f, "rb") as fp:
                print(f"[WfBench]   Reading '{f}'")
                fp.readlines()
            counter += 1
        end = time.perf_counter()
        print(f"[WfBench] [{task_name}] Metrics (read) [time,size]: {end - start},{file_size}")
print(f"[WfBench] [{task_name}] Completed IO Read Benchmark")

print(f"[WfBench] [{task_name}] Starting CPU and Memory Benchmarks...")
cpu_threads=int(10 * %f)
mem_threads=10 - cpu_threads
cpu_work=int(%i)
total_mem_bytes = 0.05
cpu_work_per_thread = int(cpu_work / cpu_threads)

cpu_procs = []
cpu_prog = [
    f"{this_dir.joinpath('cpu-benchmark')}", f"{cpu_work_per_thread}"]
mem_prog = ["/users/kmaheshw/bin/stress-ng", "--vm", f"{mem_threads}",
            "--vm-bytes", f"{total_mem_bytes}%%", "--vm-keep"]

start = time.perf_counter()
for i in range(cpu_threads):
    cpu_proc = subprocess.Popen(cpu_prog)
    cpu_procs.append(cpu_proc)

mem_proc = subprocess.Popen(mem_prog, stderr=subprocess.DEVNULL)

for proc in cpu_procs:
    proc.wait()
mem_kill = subprocess.Popen(["killall", "stress-ng"])
mem_kill.wait()
end = time.perf_counter()
print(f"[WfBench] [{task_name}] Metrics (compute) [time,work]: {end - start},{cpu_work}")
print(f"[WfBench] [{task_name}] Completed CPU and Memory Benchmarks")

print(f"[WfBench] [{task_name}] Writing output file")
start = time.perf_counter()
with open(this_dir.joinpath("%s"), "wb") as fp:
    file_size = int(%i)
    fp.write(os.urandom(file_size))
end = time.perf_counter()
print(f"[WfBench] [{task_name}] Metrics (write) [time,size]: {end - start},{file_size}")

print(f"[WfBench] [{task_name}] Benchmark completed!")
dep = %i
""";

string root_in_files[];
root_in_files[0] = "fastqSplit_00000201_input.txt";

int fastqSplit__out[];
int dep_1 = 0;
string fastqSplit_in = "";
foreach i in [0:362] {
  string of = sprintf("fastqSplit_%i_output.txt", i);
  string cmd_1 = sprintf(command, "fastqSplit", root_in_files[0], 0.9, 500, of, 1985703, dep_1);
  string co_1 = python(cmd_1);
  string of_1 = sprintf("0%s", co_1);
  fastqSplit__out[i] = string2int(of_1);
}

int filterContams__out[];
int dep_2 = fastqSplit__out[0];
string filterContams_in = "fastqSplit__363";
foreach i in [0:12316] {
  string of = sprintf("filterContams_%i_output.txt", i);
  string cmd_2 = sprintf(command, "filterContams", filterContams_in, 0.9, 500, of, 1985703, dep_2);
  string co_2 = python(cmd_2);
  string of_2 = sprintf("0%s", co_2);
  filterContams__out[i] = string2int(of_2);
}

int sol2sanger__out[];
int dep_3 = filterContams__out[0];
string sol2sanger_in = "filterContams__12317";
foreach i in [0:12316] {
  string of = sprintf("sol2sanger_%i_output.txt", i);
  string cmd_3 = sprintf(command, "sol2sanger", sol2sanger_in, 0.9, 500, of, 1985703, dep_3);
  string co_3 = python(cmd_3);
  string of_3 = sprintf("0%s", co_3);
  sol2sanger__out[i] = string2int(of_3);
}

int fast2bfq__out[];
int dep_4 = sol2sanger__out[0];
string fast2bfq_in = "sol2sanger__12317";
foreach i in [0:12316] {
  string of = sprintf("fast2bfq_%i_output.txt", i);
  string cmd_4 = sprintf(command, "fast2bfq", fast2bfq_in, 0.9, 500, of, 1985703, dep_4);
  string co_4 = python(cmd_4);
  string of_4 = sprintf("0%s", co_4);
  fast2bfq__out[i] = string2int(of_4);
}

int map__out[];
int dep_5 = fast2bfq__out[0];
string map_in = "fast2bfq__12317";
foreach i in [0:12316] {
  string of = sprintf("map_%i_output.txt", i);
  string cmd_5 = sprintf(command, "map", map_in, 0.9, 500, of, 1985703, dep_5);
  string co_5 = python(cmd_5);
  string of_5 = sprintf("0%s", co_5);
  map__out[i] = string2int(of_5);
}

int mapMerge__out[];
int dep_6 = mapMerge__out[0] + map__out[0];
string mapMerge_in = "mapMerge__363, map__12317";
foreach i in [0:363] {
  string of = sprintf("mapMerge_%i_output.txt", i);
  string cmd_6 = sprintf(command, "mapMerge", mapMerge_in, 0.9, 500, of, 1985703, dep_6);
  string co_6 = python(cmd_6);
  string of_6 = sprintf("0%s", co_6);
  mapMerge__out[i] = string2int(of_6);
}

