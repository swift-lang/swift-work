

THIS=$( realpath . )

swift-t \
  -e TURBINE_LEADER_HOOK="$( < ${THIS}/hook.tcl )" \
  workflow.swift

