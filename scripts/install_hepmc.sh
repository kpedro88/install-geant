#!/bin/bash

source init.sh

if ! [ -d HepMC3 ]; then
	git clone https://gitlab.cern.ch/hepmc/HepMC3.git
	cd HepMC3
	git checkout -b beta2.0 beta2.0
	cd ..
fi

cd HepMC3

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$LOCAL/hepmc/install -DROOT_DIR=$ROOTSYS/cmake 
make -j $1
make install

