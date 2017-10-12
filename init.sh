#!/bin/bash

export LOCAL=`pwd`/local
mkdir -p $LOCAL
export LCG=/cvmfs/sft.cern.ch/lcg/views/LCG_89/x86_64-slc6-gcc62-opt

# to get gcc+binutils
source /cvmfs/sft.cern.ch/lcg/contrib/gcc/6.2binutils/x86_64-slc6-gcc62-opt/setup.sh

# to get cmake
export PATH=/cvmfs/sft.cern.ch/lcg/contrib/CMake/3.5.2/Linux-x86_64/bin/:${PATH}

# to get python
dpython=${LOCAL}/python
if [ -d $dpython ]; then
	export PATH=${dpython}/bin:${PATH}
	export LD_LIBRARY_PATH=${dpython}/lib:${LD_LIBRARY_PATH}
	export PYTHONPATH=${LCG}/lib/python2.7/site-packages:${PYTHONPATH}
fi

# to get clhep
dclhep=${LOCAL}/clhep
if [ -d $dclhep ]; then
	export LD_LIBRARY_PATH=${dclhep}/lib:${LD_LIBRARY_PATH}
fi

# to get xercesc
dxercesc=${LOCAL}/xercesc
if [ -d $dxercesc ]; then
	export LD_LIBRARY_PATH=${dxerces}/lib:${LD_LIBRARY_PATH}
fi

# to get ROOT
thisroot=$LOCAL/root/install/bin/thisroot.sh
if [ -f $thisroot ]; then
	source $thisroot
	export PATH=${PATH}:${ROOTSYS}/bin
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROOTSYS}/lib
fi

# to get geant4
thisgeant4=$LOCAL/geant4/install
if [ -d $thisgeant4 ]; then
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${LOCAL}/geant4/install/lib64/Geant4-10.3.2
	export G4INSTALL=$LOCAL/geant4/install/share/Geant4-10.3.2
	export G4LEVELGAMMADATA=$G4INSTALL/data/PhotonEvaporation2.3
	export G4NEUTRONXSDATA=$G4INSTALL/data/G4NEUTRONXS1.4
	export G4LEDATA=$G4INSTALL/data/G4EMLOW6.39
	export G4SAIDXSDATA=$G4INSTALL/data/G4SAIDDATA1.1
	export G4RADIOACTIVEDATA=$G4INSTALL/data/RadioactiveDecay3.6
	export G4NEUTRONHPDATA=$G4INSTALL/data/G4NDL4.2
fi
