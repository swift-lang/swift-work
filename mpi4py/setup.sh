
# SETUP SH

export SPACK=/usb1/spack/opt/spack/linux-ubuntu17.10-x86_64/gcc-7.2.0



# PATH=$HOME/sfw/anaconda3/bin:$PATH
PATH=$SPACK/python-2.7.15-pwhanb3k64s3f2qxxysobl4kkhwfinvr/bin:$PATH

which swift-t python

MPI4PY=$SPACK/py-mpi4py-3.0.0-h7obgwgbzivpu4mgjhrkcsjb5a2dbzcd/lib/python2.7/site-packages

ls $MPI4PY

export PYTHONPATH=$PWD:$MPI4PY
