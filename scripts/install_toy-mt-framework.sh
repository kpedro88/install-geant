#!/bin/bash

source init.sh

SOURCEDIR=toy-mt-framework
INSTALLDIR=$LOCAL/toy-mt-framework/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone git@github.com:kpedro88/toy-mt-framework.git -b geantv2
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DVecGeom_DIR=$LOCAL/vecgeom/install/lib/CMake/VecGeom/ -DVecGeom_INCLUDE_DIR=$LOCAL/vecgeom/install/include -DGeantV_DIR=$LOCAL/geantv/install -DGeantV_INCLUDE_DIR=$LOCAL/../geant -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DTBB_ROOT_DIR=$LOCAL/tbb -DHepMC_DIR=$LOCAL/hepmc/install/share/HepMC/cmake/ -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install/lib/cmake/Vc -DBOOST_ROOT=$LOCAL/boost
make -j $1

