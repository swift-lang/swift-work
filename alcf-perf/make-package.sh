#!/bin/sh
set -eu

tclsh make-package.tcl > pkgIndex.tcl
echo wrote pkgIndex.tcl
