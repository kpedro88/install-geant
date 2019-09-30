#!/bin/bash

source init.sh

CURRDIR=`pwd`
SOURCEDIR=geant
INSTALLDIR=$LOCAL/geantv/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/GeantV/geant.git -b pre-beta-7
	cd $SOURCEDIR
	git checkout 63468c9b3b92ead35c924e8fc67c6fa13bcff493
else
	cd $SOURCEDIR
fi

if [ -d build ]; then
	rm -rf build
fi

# some really bad ways to get info out of scram
CLHEP_LIBDIR=$(scram tool info clhep | grep "LIBDIR=" | sed 's/LIBDIR=//')
CLHEP_INCLUDE=$(scram tool info clhep | grep "INCLUDE=" | sed 's/INCLUDE=//')
PYTHIA8_INCLUDE=$(scram tool info pythia8 | grep "INCLUDE=" | sed 's/INCLUDE=//')

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DVecCore_DIR=$LOCAL/veccore/install/share/VecCore/cmake/ -DUSE_VECGEOM_NAVIGATOR=ON -DVecGeom_DIR=$LOCAL/vecgeom/install/lib/cmake/VecGeom/ -DVecMath_DIR=$LOCAL/vecmath/install/lib/cmake/VecMath/ -DCMAKE_CXX_FLAGS="-O2 -std=c++14" -DUSE_ROOT=ON -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install/lib/cmake/Vc -DHepMC_DIR=$LOCAL/hepmc/install/share/HepMC/cmake/ -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCLHEP_INCLUDE_DIR=${CLHEP_INCLUDE} -DCLHEP_LIBRARY=${CLHEP_LIBDIR}/libCLHEP.so -DPYTHIA8_ROOT_DIR=${PYTHIA8_INCLUDE} -DUSE_TBB=OFF -DWITH_GEANT4=OFF -DDATA_DOWNLOAD=ON
make -j $1
make install

# allow using some extra headers from examples
mkdir -p ${INSTALLDIR}/inc/Geant/example
cp ../examples/physics/FullCMS/GeantV/inc/*.h ${INSTALLDIR}/inc/Geant/example/
cp -r ../physics/data ${INSTALLDIR}/data
# quick patch
sed -i 's~#include "GeantConfig.h"~#include "Geant/GeantConfig.h"~' ${INSTALLDIR}/inc/Geant/example/CMSPhysicsList.h

# scram stuff
# also uses Vc, HepMC3; not scram tools yet
cat << 'EOF_TOOLFILE' > geantv.xml
<tool name="GeantV" version="pre-beta-7.5">
  <info url="https://gitlab.cern.ch/GeantV/geant.git"/>
  <lib name="Geant_v"/>
  <lib name="GeantExamplesRP"/>
  <lib name="RealPhysics"/>
  <lib name="Vmagfield"/>
  <flags CXXFLAGS="-msse4.2 -pthread"/>
  <client>
    <environment name="GEANTV_BASE" default="$INSTALLDIR"/>
    <environment name="LIBDIR" default="$GEANTV_BASE/lib"/>
    <environment name="INCLUDE" default="$GEANTV_BASE/inc"/>
  </client>
  <runtime name="GEANT_PHYSICS_DATA" value="$INSTALLDIR/data"/>
  <flags CPPDEFINES="USE_ROOT"/>
  <flags CPPDEFINES="USE_VECGEOM_CONTAINERS"/>
  <flags CPPDEFINES="USE_VECGEOM_NAVIGATOR"/>
  <use name="vecgeomv"/>
  <use name="vecmath"/>
  <use name="clhep"/>
  <use name="pythia8"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' geantv.xml

mv geantv.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup geantv
