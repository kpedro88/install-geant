#!/bin/bash

source init.sh

SOURCEDIR=geant
INSTALLDIR=$LOCAL/geantv/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/GeantV/geant.git -b master
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

# some really bad ways to get info out of scram
CLHEP_LIBDIR=$(scram tool info clhep | grep "LIBDIR=" | sed 's/LIBDIR=//')
CLHEP_INCLUDE=$(scram tool info clhep | grep "INCLUDE=" | sed 's/INCLUDE=//')
PYTHIA8_INCLUDE=$(scram tool info pythia8 | grep "INCLUDE=" | sed 's/INCLUDE=//')

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DUSE_VECGEOM_NAVIGATOR=ON -DVecGeom_DIR=$LOCAL/vecgeom/install/lib/cmake/VecGeom/ -DCMAKE_CXX_FLAGS="-O2 -std=c++14" -DUSE_ROOT=ON -DCMAKE_PREFIX_PATH=$LOCAL/veccore/install/lib/cmake/Vc -DHepMC_DIR=$LOCAL/hepmc/install/share/HepMC/cmake/ -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCLHEP_INCLUDE_DIR=${CLHEP_INCLUDE} -DCLHEP_LIBRARY=${CLHEP_LIBDIR}/libCLHEP.so -DPYTHIA8_ROOT_DIR=${PYTHIA8_INCLUDE} -DUSE_TBB=OFF
make -j $1
make install

# scram stuff
# also uses Vc, HepMC3; not scram tools yet
cat << 'EOF_TOOLFILE' > geantv.xml
<tool name="GeantV" version="master">
  <info url="https://gitlab.cern.ch/GeantV/geant.git"/>
  <use name="vecgeomV"/>
  <use name="clhep"/>
  <use name="pythia8"/>
</tool>
EOF_TOOLFILE

mv geantv.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup geantv
