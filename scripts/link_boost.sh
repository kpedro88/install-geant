#!/bin/bash

source init.sh

LIBS=(
libboost_wserialization.so \
libboost_math_c99.so \
libboost_fiber.a \
libboost_filesystem.so \
libboost_regex.so \
libboost_program_options.so.1.64.0 \
libboost_log.a \
libboost_context.so \
libboost_wserialization.so.1.64.0 \
libboost_math_c99.a \
libboost_random.so.1.64.0 \
libboost_log.so \
libboost_context.a \
libboost_prg_exec_monitor.so.1.64.0 \
libboost_log_setup.so \
libboost_math_tr1f.so \
libboost_thread.so.1.64.0 \
libboost_signals.a \
libboost_log_setup.so.1.64.0 \
libboost_type_erasure.so.1.64.0 \
libboost_unit_test_framework.a \
libboost_math_c99f.a \
libboost_fiber.so \
libboost_math_c99f.so \
libboost_date_time.so.1.64.0 \
libboost_atomic.a \
libboost_timer.so.1.64.0 \
libboost_iostreams.so \
libboost_thread.so \
libboost_signals.so.1.64.0 \
libboost_timer.so \
libboost_system.a \
libboost_regex.so.1.64.0 \
libboost_math_c99l.a \
libboost_locale.a \
libboost_chrono.so.1.64.0 \
libboost_container.so.1.64.0 \
libboost_prg_exec_monitor.a \
libboost_math_c99.so.1.64.0 \
libboost_wserialization.a \
libboost_wave.so.1.64.0 \
libboost_graph.so.1.64.0 \
libboost_type_erasure.so \
libboost_python.so \
libboost_regex.a \
libboost_filesystem.so.1.64.0 \
libboost_unit_test_framework.so \
libboost_coroutine.so \
libboost_chrono.a \
libboost_timer.a \
libboost_fiber.so.1.64.0 \
libboost_system.so \
libboost_math_c99l.so \
libboost_python.a \
libboost_log_setup.a \
libboost_type_erasure.a \
libboost_signals.so \
libboost_date_time.a \
libboost_serialization.so.1.64.0 \
libboost_chrono.so \
libboost_serialization.a \
libboost_wave.a \
libboost_unit_test_framework.so.1.64.0 \
libboost_test_exec_monitor.a \
libboost_math_c99l.so.1.64.0 \
libboost_locale.so \
libboost_program_options.a \
libboost_log.so.1.64.0 \
libboost_math_tr1.a \
libboost_wave.so \
libboost_system.so.1.64.0 \
libboost_program_options.so \
libboost_math_tr1.so \
)

# link boost
BOOSTDIR=${LOCAL}/boost
mkdir ${BOOSTDIR}
mkdir ${BOOSTDIR}/include
ln -s ${LCG}/include/boost ${BOOSTDIR}/include/boost
mkdir ${BOOSTDIR}/lib
for LIB in ${LIBS[@]}; do
	ln -s ${LCG}/lib/${LIB} ${BOOSTDIR}/lib/${LIB}
done
