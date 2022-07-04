
# HOOK TCL
# This code runs on each leader rank,
#      i.e., once per node.

# Set a root data directory
set root /home/$env(USER)/data
puts "HOOK HOST: [exec hostname]"

# Get the leader communicator from ADLB
set comm [ adlb::comm_get leaders ]
# Get my rank among the leaders
set rank [ adlb::comm_rank $comm ]

# If I am rank=0, discover all files in the root directory
if { $rank == 0 } {
  set files [ ::glob -type f $root/* ]
  puts "files: $files"
}

# Broadcast the file list to all leaders
turbine::c::bcast $comm 0 files

# Make a node-local data directory
file mkdir /tmp/$env(USER)/data

# Copy each file to the node-local directory
foreach f $files {
  if { $rank == 0 } {
    puts "copying: $f"
  }
  turbine::c::copy_to $comm $f /tmp/$env(USER)/data
}
