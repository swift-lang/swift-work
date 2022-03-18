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

dep = 42
""";

string cmd2 = """
def noop():
  # %s %s
  %f
  %i
  # %s
  %i
  %i
""";

string root_in_files[];
root_in_files[0] = "fastqSplit_00000201_input.txt";

int fastqSplit__out[];
int dep_1 = 0;
string fastqSplit_in = "";
foreach i in [0:362] {
  string of = sprintf("fastqSplit_%i_output.txt", i);
//  string cmd_1 = sprintf(command, "fastqSplit", root_in_files[0], 0.9, 500, of, 1985703, dep_1);
  string co_1 = python(command);
  string of_1 = sprintf("0%s", co_1);
  fastqSplit__out[i] = string2int(of_1);
}

int filterContams__out[];
int dep_2 = fastqSplit__out[0];
string filterContams_in = "fastqSplit__363";
foreach i in [0:12316] {
  string of = sprintf("filterContams_%i_output.txt", i);
  // string cmd_2 = sprintf(command, "filterContams", filterContams_in, 0.9, 500, of, 1985703, dep_2);

  string co_2 = python_persist(command);
  string of_2 = sprintf("0%s", co_2);
  filterContams__out[i] = string2int(of_2);
}

int sol2sanger__out[];
int dep_3 = filterContams__out[0];
string sol2sanger_in = "filterContams__12317";
foreach i in [0:12316] {
  string of = sprintf("sol2sanger_%i_output.txt", i);
  // string cmd_3 = sprintf(command, "sol2sanger", sol2sanger_in, 0.9, 500, of, 1985703, dep_3);
  string co_3 = python_persist(command);
  string of_3 = sprintf("0%s", co_3);
  sol2sanger__out[i] = string2int(of_3);
}

int fast2bfq__out[];
int dep_4 = sol2sanger__out[0];
string fast2bfq_in = "sol2sanger__12317";
foreach i in [0:12316] {
  string of = sprintf("fast2bfq_%i_output.txt", i);
   // string cmd_4 = sprintf(command, "fast2bfq", fast2bfq_in, 0.9, 500, of, 1985703, dep_4);
  string co_4 = python_persist(command);
  string of_4 = sprintf("0%s", co_4);
  fast2bfq__out[i] = string2int(of_4);
}

printf("5");

int map__out[];
int dep_5 = fast2bfq__out[0];
string map_in = "fast2bfq__12317";
foreach i in [0:12316] {
  string of = sprintf("map_%i_output.txt", i);
  // string cmd_5 = sprintf(command, "map", map_in, 0.9, 500, of, 1985703, dep_5);
  string co_5 = python_persist(command);
  string of_5 = sprintf("0%s", co_5);
  map__out[i] = string2int(of_5);
}

printf("6");

int mapMerge__out[];
int dep_6 = mapMerge__out[0] + map__out[0];
string mapMerge_in = "mapMerge__363, map__12317";
foreach i in [0:362] {
  string of = sprintf("mapMerge_%i_output.txt", i);
  // string cmd_6 = sprintf(command, "mapMerge", mapMerge_in, 0.9, 500, of, 1985703, dep_6);
  string co_6 = python(command);
  string of_6 = sprintf("0%s", co_6);
  mapMerge__out[i] = string2int(of_6);
}

wait deep (mapMerge__out) { printf("DONE!"); }
