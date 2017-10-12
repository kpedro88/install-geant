#!/bin/bash

source init.sh

if ! [ -d root-6.10.02 ]; then
	wget https://root.cern.ch/download/root_v6.10.02.source.tar.gz
	tar -xzf root_v6.10.02.source.tar.gz
	rm root_v6.10.02.source.tar.gz
fi

cd root-6.10.02

if [ -d build_ ]; then
	rm -rf build_
fi

mkdir build_
cd build_
cmake ../ -DCMAKE_INSTALL_PREFIX=$LOCAL/root/install -Dc++11=ON -Dgdml=ON -Dmathmore=ON -Dshared_gsl=ON -Dbuiltin_xrootd=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DPYTHON_INCLUDE_DIR=${LCG}/include/python2.7
make -j $1
make install

