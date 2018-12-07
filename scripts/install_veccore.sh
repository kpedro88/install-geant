#!/bin/bash

source init.sh

SOURCEDIR=veccore
INSTALLDIR=$LOCAL/veccore/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://github.com/root-project/veccore.git -b v0.5.2
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DBUILD_UMESIMD="ON" -DBUILD_VC="ON" -DCMAKE_EXPORT_COMPILE_COMMANDS=1
make -j $1
make install

# scram stuff
cat << 'EOF_TOOLFILE' > veccore.xml
<tool name="VecCore" version="0.5.2">
  <info url="https://github.com/root-project/veccore.git"/>
  <client>
    <environment name="VECCORE_BASE" default="$INSTALLDIR"/>
    <environment name="INCLUDE" default="$VECCORE_BASE/include"/>
  </client>
  <flags CPPDEFINES="VECCORE_ENABLE_VC"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' veccore.xml

mv veccore.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup veccore

