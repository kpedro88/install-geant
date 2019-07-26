#!/bin/bash

source init.sh

CURRDIR=`pwd`
SOURCEDIR=spack
OPENSS_BASEDIR=${CURRDIR}/${SOURCEDIR}/var/spack/environments/openss

if [ "$FORCERECOMP" = "true" ]; then
	rm -rf $SOURCEDIR
fi

if ! [ -d $SOURCEDIR ]; then
	git clone https://github.com/spack/spack.git
fi
cd $SOURCEDIR

# some really bad ways to get info out of scram
BOOST_BASEDIR=$(scram tool info boost | grep "BOOST_BASE=" | sed 's/BOOST_BASE=//')
GCC_BASEDIR=$(scram tool info gcc-ccompiler | grep "GCC_CCOMPILER_BASE=" | sed 's/GCC_CCOMPILER_BASE=//')
OPENMPI_BASEDIR=$(scram tool info openmpi | grep "OPENMPI_BASE=" | sed 's/OPENMPI_BASE=//')
PYTHON_BASEDIR=$(scram tool info python | grep "PYTHON_BASE=" | sed 's/PYTHON_BASE=//')

# keep spack contained
export PATH=${CURRDIR}/${SOURCEDIR}/bin:${PATH}
if [ -d $OPENSS_BASEDIR ]; then
	spack env remove -y openss
fi
spack env create openss
eval `spack env activate --sh openss`

# handle discrepancy in boost version
SPACK_PKG_DIR=${CURRDIR}/${SOURCEDIR}/var/spack/repos/builtin/packages
for PKG in cbtf cbtf-krell cbtf-argonavis openspeedshop openspeedshop-utils; do
	sed -i 's/depends_on("boost@1.66.0:1.69.0")/depends_on("boost@1.66.0:1.70.0")/' ${SPACK_PKG_DIR}/${PKG}/package.py
done

# because curl won't follow redirects?
for FILE in $(git grep -l ftpmirror); do
	sed -i 's~https://ftpmirror.gnu.org~https://mirrors.kernel.org/gnu~' $FILE
done

# specify fixed packages & compiler
cat << EOF_YAML > ${OPENSS_BASEDIR}/fixed.yaml
compilers:
- compiler:
    environment: {}
    extra_rpaths: []
    flags: {}
    modules: []
    operating_system: scientificfermi6
    paths:
      cc: ${GCC_BASEDIR}/bin/gcc
      cxx: ${GCC_BASEDIR}/bin/g++
      f77: ${GCC_BASEDIR}/bin/gfortran
      fc: ${GCC_BASEDIR}/bin/gfortran
    spec: gcc@$(basename $GCC_BASEDIR)
    target: x86_64

packages:
  binutils:
    buildable: False
    paths:
      binutils: ${GCC_BASEDIR}
  boost:
    buildable: False
    paths:
      boost: ${BOOST_BASEDIR}
  cmake:
    buildable: False
    paths:
      cmake: ${CMAKE_BASEDIR}
  openmpi:
    buildable: False
    paths:
      openmpi: ${OPENMPI_BASEDIR}
  python:
    buildable: False
    paths:
      python: ${PYTHON_BASEDIR}
EOF_YAML

# load into central yaml
cat << EOF_YAML >> ${OPENSS_BASEDIR}/spack.yaml
  include:
  - ${OPENSS_BASEDIR}/fixed.yaml
EOF_YAML

# actually install
#spack install -j $1 openspeedshop@2.3.15 +openmpi
spack install -v -j $1 openspeedshop +openmpi

# scram stuff
cat << EOF_TOOLFILE > openss.xml
<tool name="openss" version="2.4.1">
  <info url="https://sourceforge.net/projects/openss/files/openss/"/>
  <client>
    <environment name="OPENSS_BASE" default="${INSTALLDIR}/osscbtf_v2.3"/>
  </client>
  <use name="python"/>
  <use name="openmpi"/>
  <use name="boost"/>
</tool>
EOF_TOOLFILE

mv openss.xml ${CMSSW_BASE}/config/toolbox/${SCRAM_ARCH}/tools/selected/
scram setup openss
