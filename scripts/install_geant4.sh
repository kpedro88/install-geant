#!/bin/bash

source init.sh

SOURCEDIR=geant4.10.03.p02

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	wget -q http://cern.ch/geant4/support/source/geant4.10.03.p02.tar.gz
	tar -xzf geant4.10.03.p02.tar.gz
	rm geant4.10.03.p02.tar.gz
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$LOCAL/geant4/install -DGEANT4_INSTALL_DATA=ON -DGEANT4_USE_GDML=ON -DXERCESC_ROOT_DIR=$LOCAL/xercesc -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

