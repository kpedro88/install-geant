#!/bin/bash

source init.sh

SOURCEDIR=HepMC3
INSTALLDIR=$LOCAL/hepmc/install

if [ -d $INSTALLDIR ]; then
    rm -rf $INSTALLDIR
fi

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://gitlab.cern.ch/hepmc/HepMC3.git
	cd HepMC3
	git checkout -b beta2.0 beta2.0
	cd ..
fi

cd $SOURCEDIR

if [ -d build ]; then
	rm -rf build
fi

mkdir build
cd build
cmake ../ $DEBUGFLAG -DCMAKE_INSTALL_PREFIX=$INSTALLDIR -DROOT_DIR=$ROOTSYS/cmake 
make -j $1
make install

# scram stuff
# install as hepmc3 to avoid conflict with default hepmc=hepmc2
cat << 'EOF_TOOLFILE' > hepmc3.xml
<tool name="HepMC3" version="beta2.0">
  <lib name="HepMCfio"/>
  <lib name="HepMC"/>
  <client>
    <environment name="HEPMC_BASE" default="$INSTALLDIR"/>
    <environment name="LIBDIR" default="$HEPMC_BASE/lib64"/>
  </client>
  <use name="hepmc3_headers"/>
  <runtime name="CMSSW_FWLITE_INCLUDE_PATH" value="$HEPMC_BASE/include" type="path"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' hepmc3.xml

cat << 'EOF_TOOLFILE' > hepmc3_headers.xml
<tool name="hepmc_headers" version="beta2.0">
  <client>
    <environment name="HEPMC_HEADERS_BASE" default="$INSTALLDIR"/>
    <environment name="INCLUDE" default="$HEPMC_HEADERS_BASE/include"/>
  </client>
  <runtime name="ROOT_INCLUDE_PATH"  value="$INCLUDE" type="path"/>
  <use name="root_cxxdefaults"/>
</tool>
EOF_TOOLFILE
sed -i 's~$INSTALLDIR~'$INSTALLDIR'~' hepmc3_headers.xml

mv hepmc3_headers.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected
scram setup hepmc3_headers
mv hepmc3.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected
scram setup hepmc3

