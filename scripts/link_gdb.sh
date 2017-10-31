#!/bin/bash

source init.sh

# link python
GDBDIR=${LOCAL}/gdb
mkdir ${GDBDIR}
mkdir ${GDBDIR}/bin
ln -s ${LCG}/bin/gdb ${GDBDIR}/bin/gdb
mkdir ${GDBDIR}/lib
ln -s ${LCG}/lib/libexpat.so.1 ${GDBDIR}/lib/libexpat.so.1

