#!/bin/bash

source init.sh

# link clhep
CLHEPDIR=${LOCAL}/clhep
mkdir ${CLHEPDIR}
mkdir ${CLHEPDIR}/include
ln -s ${LCG}/include/CLHEP ${CLHEPDIR}/include/CLHEP
mkdir ${CLHEPDIR}/lib
ln -s ${LCG}/lib/libCLHEP.so ${CLHEPDIR}/lib/libCLHEP.so

