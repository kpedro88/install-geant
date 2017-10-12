#!/bin/bash

source init.sh

if ! [ -d pythia8186 ]; then
	wget http://home.thep.lu.se/~torbjorn/pythia8/pythia8186.tgz
	tar -xzf pythia8186.tgz
	rm pythia8186.tgz
fi

cd pythia8186

./configure --prefix=$LOCAL/pythia8/install --enable-shared
make -j $1
make install

