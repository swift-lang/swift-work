
set root /home/$env(USER)/data
set comm [ adlb::comm_leaders ]
if { [ adlb::rank $comm ] == 0 } {
  set files [ ::glob -type f $root/* ]
}

turbine::c::bcast $comm 0 files

file mkdir /tmp/$env(USER)/data

foreach f $files {
  if { [ adlb::rank $comm ] == 0 } {
    puts "copying: $f"
  }
  turbine::c::copy_to $comm $f /tmp/$env(USER)/data
}
