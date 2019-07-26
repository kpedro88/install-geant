#!/bin/tcsh

setenv LOCAL `pwd`/local
mkdir -p $LOCAL

# to get cmake
setenv CMAKE_BASEDIR /cvmfs/sft.cern.ch/lcg/contrib/CMake/3.7.0/Linux-x86_64
setenv PATH ${CMAKE_BASEDIR}/bin/:${PATH}
