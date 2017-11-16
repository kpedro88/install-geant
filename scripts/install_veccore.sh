#!/bin/bash

source init.sh

SOURCEDIR=veccore

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://github.com/root-project/veccore.git
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$LOCAL/veccore/install -DBUILD_UMESIMD="ON" -DBUILD_VC="ON" -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

