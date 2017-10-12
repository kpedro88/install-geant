#!/bin/bash

source init.sh

if ! [ -d geant4.10.03.p02 ]; then
	wget -q http://cern.ch/geant4/support/source/geant4.10.03.p02.tar.gz
	tar -xzf geant4.10.03.p02.tar.gz
	rm geant4.10.03.p02.tar.gz
fi

cd geant4.10.03.p02

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$LOCAL/geant4/install -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_GDML=ON -DXERCESC_ROOT_DIR=$LOCAL/xercesc -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

