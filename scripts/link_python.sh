#!/bin/bash

source init.sh

# link python
PYTHONDIR=${LOCAL}/python
mkdir ${PYTHONDIR}
mkdir ${PYTHONDIR}/bin
ln -s ${LCG}/bin/python ${PYTHONDIR}/bin/python
mkdir ${PYTHONDIR}/lib
ln -s ${LCG}/lib/libpython2.7.so ${PYTHONDIR}/lib/libpython2.7.so
ln -s ${LCG}/lib/libpython2.7.so.1.0 ${PYTHONDIR}/lib/libpython2.7.so.1.0

