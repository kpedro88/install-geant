#!/bin/bash

source init.sh

SOURCEDIR=VecGeom
INSTALLDIR=$LOCAL/vecgeom/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/VecGeom/VecGeom.git -b v00.05.01
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install -DBUILTIN_VECCORE=OFF -DBACKEND=Vc -DVc=ON -DVECGEOM_VECTOR=sse4.2 -DUSOLIDS=ON -DROOT=ON -DBENCHMARK=ON -DCTEST=ON -DVALIDATION=OFF -DNO_SPECIALIZATION=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_CXX_STANDARD=14
make -j $1
make install

# scram stuff
# install as a separate tool to avoid conflicts with scalar version used in geant4 (or massive recompiling)
cat << 'EOF_TOOLFILE' > vecgeomv_interface.xml
<tool name="vecgeomv_interface" version="v00.05.01">
  <info url="https://gitlab.cern.ch/VecGeom/VecGeom"/>
  <client>
    <environment name="VECGEOM_INTERFACE_BASE" default="$INSTALLDIR"/>
    <environment name="INCLUDE" default="$VECGEOM_INTERFACE_BASE/include"/>
  </client>
  <flags CPPDEFINES="VECGEOM_REPLACE_USOLIDS"/>
  <flags CPPDEFINES="VECGEOM_NO_SPECIALIZATION"/>
  <flags CPPDEFINES="VECGEOM_USOLIDS"/>
  <flags CPPDEFINES="VECGEOM_INPLACE_TRANSFORMATIONS"/>
  <flags CPPDEFINES="VECGEOM_USE_INDEXEDNAVSTATES"/>
  <flags CPPDEFINES="VECGEOM_QUADRILATERALS_VC"/>
  <flags CPPDEFINES="VECGEOM_VC"/>
  <flags CPPDEFINES="VECGEOM_ROOT"/>
  <runtime name="ROOT_INCLUDE_PATH" value="$INCLUDE" type="path"/>
  <use name="root_cxxdefaults"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' vecgeomv_interface.xml

cat << 'EOF_TOOLFILE' > vecgeomv.xml
<tool name="vecgeomv" version="v00.05.01">
  <info url="https://gitlab.cern.ch/VecGeom/VecGeom"/>
  <lib name="vecgeom"/>
  <lib name="usolids"/>
  <flags CXXFLAGS="-msse4.2 -pthread"/>
  <client>
    <environment name="VECGEOM_BASE" default="$INSTALLDIR"/>
    <environment name="LIBDIR" default="$VECGEOM_BASE/lib"/>
  </client>
  <use name="vecgeomv_interface"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' vecgeomv.xml

mv vecgeomv_interface.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected
scram setup vecgeomv_interface
mv vecgeomv.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected
scram setup vecgeomv

