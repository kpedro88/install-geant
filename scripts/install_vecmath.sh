#!/bin/bash

source init.sh

SOURCEDIR=vecmath
INSTALLDIR=$LOCAL/vecmath/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://github.com/kpedro88/vecmath.git
	cd $SOURCEDIR
	git reset --hard 5095831
else
	cd $SOURCEDIR
fi


if [ -d build ]; then
	rm -rf build
fi

# some really bad ways to get info out of scram
VDT_DIR=$(scram tool info vdt | grep "VDT_BASE=" | sed 's/VDT_BASE=//')

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install -DVDT_DIR=${VDT_DIR} -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

# scram stuff
cat << 'EOF_TOOLFILE' > vecmath.xml
<tool name="VecMath" version="5095831">
  <info url="https://github.com/root-project/vecmath.git"/>
  <client>
    <environment name="VECMATH_BASE" default="$INSTALLDIR"/>
    <environment name="INCLUDE" default="$VECMATH_BASE/include"/>
  </client>
  <use name="vdt"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' vecmath.xml

mv vecmath.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup vecmath

