#!/bin/tcsh

setenv LOCAL `pwd`/local
mkdir -p $LOCAL

# to get cmake
setenv PATH /cvmfs/sft.cern.ch/lcg/contrib/CMake/3.7.0/Linux-x86_64/bin/:${PATH}
