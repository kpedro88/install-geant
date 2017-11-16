#!/bin/bash

source init.sh

SOURCEDIR=HepMC3

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/hepmc/HepMC3.git
	cd HepMC3
	git checkout -b beta2.0 beta2.0
	cd ..
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$LOCAL/hepmc/install -DROOT_DIR=$ROOTSYS/cmake 
make -j $1
make install

