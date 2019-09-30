#!/bin/bash

source init.sh

SOURCEDIR=Vc
INSTALLDIR=$LOCAL/oldvc/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi
mkdir -p $INSTALLDIR

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://github.com/VcDevel/Vc -b 1.2.0
	cd $SOURCEDIR

	# apply patch for gcc6 incompatibility
	wget https://github.com/VcDevel/Vc/commit/7b27d13a395c4acb460c7e81fc20ae01a8c763cf.patch
	git apply 7b27d13a395c4acb460c7e81fc20ae01a8c763cf.patch
else
	cd $SOURCEDIR
fi

if [ -d build ]; then
	rm -rf build
fi
mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DBUILD_TESTING=OFF
make -j $1
make install
