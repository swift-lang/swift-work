set name     evaluate
set version  0.0

puts [ ::pkg::create -name $name -version $version \
           -source evaluate.tcl ]
