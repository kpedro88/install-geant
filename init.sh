#!/bin/bash

export LOCAL=`pwd`/local
mkdir -p $LOCAL

# to get cmake
export PATH=/cvmfs/sft.cern.ch/lcg/contrib/CMake/3.6.0/Linux-x86_64/bin/:${PATH}
