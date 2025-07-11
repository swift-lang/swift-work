
/*
  WORKFLOW SWIFT
*/

import io;
import sys;

// Command line processing:
int n = string2int(argv("n"));
printf("TASKS: %i", n);

// Define work types: 
pragma worktypedef CPU;
pragma worktypedef GPU;

// Define two work typed tasks.
// These just run ./task.sh

@dispatch=CPU
task_cpu (int i) "turbine" "0.0"
  [ "global env ; puts [ exec $env(THIS)/task.sh CPU <<i>> ]" ];

@dispatch=GPU
task_gpu (int i) "turbine" "0.0"
  [ "global env ; puts [ exec $env(THIS)/task.sh GPU <<i>> ]" ];

// Issue the tasks:
foreach i in [0:n-1]
{
  task_cpu(1);
  task_gpu(1);
}
