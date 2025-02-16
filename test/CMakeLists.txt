#
# Copyright (c) 2020 Nutanix Inc. All rights reserved.
#
# Authors: Thanos Makatos <thanos@nutanix.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Nutanix nor the names of its contributors may be
#       used to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

if (WITH_ASAN EQUAL 1)
  unset(valgrind)
else()
  set(valgrind_path "/usr/bin/valgrind")
  set(valgrind_args "--error-exitcode=1 --exit-on-first-error=yes --leak-check=full --quiet")
  set(valgrind_args "${valgrind_args} --show-leak-kinds=all --track-origins=yes")
  set(valgrind_args "${valgrind_args} --suppressions=${CMAKE_CURRENT_SOURCE_DIR}/valgrind.supp")
  separate_arguments(valgrind_args)
  set(valgrind ${valgrind_path} ${valgrind_args})
endif()

add_executable(unit-tests unit-tests.c mocks.c
		../lib/dma.c
		../lib/irq.c
		../lib/libvfio-user.c
		../lib/migration.c
		../lib/pci.c
		../lib/pci_caps.c
		../lib/tran.c
		../lib/tran_pipe.c
		../lib/tran_sock.c)

target_link_libraries(unit-tests PUBLIC cmocka dl json-c)

target_compile_definitions(unit-tests PUBLIC UNIT_TEST)

enable_testing()
add_test(NAME unit-tests COMMAND ${valgrind} ${CMAKE_CURRENT_BINARY_DIR}/unit-tests)
add_test(NAME lspci COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/test-lspci.sh)
add_test(NAME client-server COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/test-client-server.sh)
