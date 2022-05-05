
valgrind_native_args = [
  '--error-exitcode=1',
  '--exit-on-first-error=yes',
  '--leak-check=full',
  '--quiet',
  '--show-leak-kinds=all',
  '--track-origins=yes',
  '--suppressions=' + ( meson.current_source_dir() / 'valgrind.supp' ),
]

unit_tests_sources = [
  'unit-tests.c',
  'mocks.c',
  '../lib/dma.c',
  '../lib/irq.c',
  '../lib/libvfio-user.c',
  '../lib/migration.c',
  '../lib/pci.c',
  '../lib/pci_caps.c',
  '../lib/tran.c',
  '../lib/tran_pipe.c',
  '../lib/tran_sock.c',
]

unit_tests_deps = [
  json_c_dep,
  cmocka_dep,
  dl_dep,
]
unit_tests_cflags = [
  '-DUNIT_TEST',
  '-DWITH_TRAN_PIPE',
]

unit_tests = executable(
  'unit_tests',
  unit_tests_sources,
  c_args: unit_tests_cflags + common_cflags,
  dependencies: unit_tests_deps,
  include_directories: public_include_dir + lib_include_dir,
  install: false,
)

test(
  'unit_tests',
  unit_tests,
  suite: 'native',
)

if opt_valgrind
  test(
    'valgrind-unit_tests',
    valgrind,
    is_parallel : false,
    suite: 'valgrind',
    args: valgrind_native_args + [unit_tests],
  )
endif

test(
  'test-lspci',
  find_program('test-lspci.sh'),
  suite: 'native',
  args: [lspci],
)

test_cs_timeout = 30
if opt_sanitizers != 'none'
  test_cs_timeout = 300
endif

test(
  'test-client-server',
  find_program('test-client-server.sh'),
  timeout: test_cs_timeout,
  suite: 'native',
  args: [client, server],
)

if opt_valgrind and opt_sanitizers == 'none'
  test(
    'valgrind-test-client-server',
    valgrind,
    timeout: test_cs_timeout,
    suite: 'valgrind',
    is_parallel : false,
    env: environment({'VALGRIND': '1'}),
    args: [find_program('test-client-server.sh').full_path(), client, server],
  )
endif

if opt_sanitizers == 'none'
  test(
    'test-linkage.sh',
    find_program('test-linkage.sh'),
    suite: 'native',
    args: [
      meson.source_root(),
      meson.build_root(),
      ' '.join(cc.cmd_array()),
    ]
  )
endif

subdir('py')
