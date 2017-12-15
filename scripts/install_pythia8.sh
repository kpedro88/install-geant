#!/bin/bash

source init.sh

SOURCEDIR=pythia8186
INSTALLDIR=$LOCAL/pythia8/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	wget -q http://home.thep.lu.se/~torbjorn/pythia8/pythia8186.tgz
	tar -xzf pythia8186.tgz
	rm pythia8186.tgz
fi

cd $SOURCEDIR

DEBUGFLAGPYTHIA=""
if [ -n "$DEBUGFLAG" ]; then
	DEBUGFLAGPYTHIA=--enable-debug
fi

./configure $DEBUGFLAGPYTHIA --prefix=$INSTALLDIR --enable-shared
make -j $1
make install

