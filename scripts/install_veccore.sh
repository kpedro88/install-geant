#!/bin/bash

source init.sh

if ! [ -d veccore ]; then
	git clone https://github.com/root-project/veccore.git
fi

cd veccore

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=$LOCAL/veccore/install -DBUILD_UMESIMD="ON" -DBUILD_VC="ON" -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

