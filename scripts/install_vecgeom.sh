#!/bin/bash

source init.sh

SOURCEDIR=VecGeom
INSTALLDIR=$LOCAL/vecgeom/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/VecGeom/VecGeom.git -b v0.5
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install -DBUILTIN_VECCORE=OFF -DBACKEND=Vc -DVc=ON -DVECGEOM_VECTOR=sse4.2 -DUSOLIDS=ON -DROOT=ON -DBENCHMARK=ON -DCTEST=ON -DVALIDATION=OFF -DNO_SPECIALIZATION=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

