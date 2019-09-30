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

# just copy header files that are missing from CMSSW
cp -r include $INSTALLDIR
for i in avx common mic scalar sse traits; do
	cp -r $i $INSTALLDIR/include/Vc
done
