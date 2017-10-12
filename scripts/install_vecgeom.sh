#!/bin/bash

source init.sh

if ! [ -d VecGeom ]; then
	git clone https://gitlab.cern.ch/VecGeom/VecGeom.git
fi

cd VecGeom

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$LOCAL/vecgeom/install -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install -DBUILTIN_VECCORE=OFF -DBACKEND=Vc -DVc=ON -DVECGEOM_VECTOR=avx -DUSOLIDS=ON -DROOT=ON -DBENCHMARK=ON -DCTEST=ON -DVALIDATION=OFF -DNO_SPECIALIZATION=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

