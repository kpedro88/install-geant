#!/bin/bash

export LOCAL=`pwd`/local
mkdir -p $LOCAL

# to get cmake
export CMAKE_BASEDIR=/cvmfs/sft.cern.ch/lcg/contrib/CMake/3.7.0/Linux-x86_64
export PATH=${CMAKE_BASEDIR}/bin/:${PATH}
