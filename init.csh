#!/bin/tcsh

setenv LOCAL `pwd`/local
mkdir -p $LOCAL
setenv LCG /cvmfs/sft.cern.ch/lcg/views/LCG_89/x86_64-slc6-gcc62-opt

# to get gcc+binutils
source /cvmfs/sft.cern.ch/lcg/contrib/gcc/6.2binutils/x86_64-slc6-gcc62-opt/setup.csh

# to get cmake
setenv PATH /cvmfs/sft.cern.ch/lcg/contrib/CMake/3.5.2/Linux-x86_64/bin/:${PATH}

# to get python
set dpython=${LOCAL}/python
if ( -d $dpython ) then
	setenv PATH ${dpython}/bin:${PATH}
	setenv LD_LIBRARY_PATH ${dpython}/lib:${LD_LIBRARY_PATH}
	setenv PYTHONPATH ${LCG}/lib/python2.7/site-packages:${PYTHONPATH}
endif

# to get clhep
set dclhep=${LOCAL}/clhep
if ( -d $dclhep ) then
	setenv LD_LIBRARY_PATH ${dclhep}/lib:${LD_LIBRARY_PATH}
endif

# to get xercesc
set dxercesc=${LOCAL}/xercesc
if ( -d $dxercesc ) then
	setenv LD_LIBRARY_PATH ${dxerces}/lib:${LD_LIBRARY_PATH}
endif

# to get ROOT
set thisroot=$LOCAL/root/install/bin/thisroot.csh
if ( -f $thisroot ) then
	source $thisroot
	setenv PATH ${PATH}:${ROOTSYS}/bin
	setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${ROOTSYS}/lib
endif

# to get geant4
set thisgeant4=$LOCAL/geant4/install
if ( -d $thisgeant4 ) then
	setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${LOCAL}/geant4/install/lib64/Geant4-10.3.2
	setenv G4INSTALL $LOCAL/geant4/install/share/Geant4-10.3.2
	setenv G4LEVELGAMMADATA $G4INSTALL/data/PhotonEvaporation2.3
	setenv G4NEUTRONXSDATA $G4INSTALL/data/G4NEUTRONXS1.4
	setenv G4LEDATA $G4INSTALL/data/G4EMLOW6.39
	setenv G4SAIDXSDATA $G4INSTALL/data/G4SAIDDATA1.1
	setenv G4RADIOACTIVEDATA $G4INSTALL/data/RadioactiveDecay3.6
	setenv G4NEUTRONHPDATA $G4INSTALL/data/G4NDL4.2
endif
