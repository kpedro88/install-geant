#!/bin/bash

source init.sh

SOURCEDIR=root
INSTALLDIR=$LOCAL/root/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://github.com/root-project/root.git
fi

cd $SOURCEDIR

if [ -d build_ ]; then
	rm -rf build_
fi

mkdir build_
cd build_
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -Dc++11=ON -Dgdml=ON -Dmathmore=ON -Dshared_gsl=ON -Dbuiltin_xrootd=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DPYTHON_INCLUDE_DIR=${LCG}/include/python2.7
make -j $1
make install

