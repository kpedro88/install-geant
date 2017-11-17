#!/bin/bash

source init.sh

SOURCEDIR=geant

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/GeantV/geant.git -b agheata/task_mode
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$LOCAL/geantv/install -DUSE_VECGEOM_NAVIGATOR=ON -DVecGeom_DIR=$LOCAL/vecgeom/install/lib/CMake/VecGeom/ -DCMAKE_CXX_FLAGS="-O2 -std=c++11" -DUSE_ROOT=ON -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install/lib/cmake/Vc -DHepMC_DIR=$LOCAL/hepmc/install/share/HepMC/cmake/ -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DGeant4_DIR=${LOCAL}/geant4/install/lib64/Geant4-10.3.2 -DCLHEP_INCLUDE_DIR=${LOCAL}/clhep/include -DCLHEP_LIBRARY=${LOCAL}/clhep/lib/libCLHEP.so -DPYTHIA8_ROOT_DIR=$LOCAL/pythia8/install -DUSE_TBB=OFF
make -j $1
make install

