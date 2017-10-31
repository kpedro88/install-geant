#!/bin/bash

source init.sh

if ! [ -d toy-mt-framework ]; then
	git clone git@github.com:kpedro88/toy-mt-framework.git -b geantv
fi

cd toy-mt-framework

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$LOCAL/toy-mt-framework/install -DVecGeom_DIR=$LOCAL/vecgeom/install/lib/CMake/VecGeom/ -DVecGeom_INCLUDE_DIR=$LOCAL/vecgeom/install/include -DGeantV_DIR=$LOCAL/geantv/install -DGeantV_INCLUDE_DIR=$LOCAL/../geant -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DTBB_ROOT_DIR=$LOCAL/tbb -DHepMC_DIR=$LOCAL/hepmc/install/share/HepMC/cmake/ -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install/lib/cmake/Vc -DBOOST_ROOT=$LOCAL/boost
make -j $1

