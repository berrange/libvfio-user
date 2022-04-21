

python_tests_common = [
  'libvfio_user.py',
]

python_tests = [
  'test_destroy.py',
  'test_device_get_info.py',
  'test_device_get_irq_info.py',
  'test_device_get_region_info.py',
  'test_device_get_region_info_zero_size.py',
  'test_device_get_region_io_fds.py',
  'test_device_set_irqs.py',
  'test_dirty_pages.py',
  'test_dma_map.py',
  'test_dma_unmap.py',
  'test_irq_trigger.py',
  'test_map_unmap_sg.py',
  'test_migration.py',
  'test_negotiate.py',
  'test_pci_caps.py',
  'test_pci_ext_caps.py',
  'test_quiesce.py',
  'test_request_errors.py',
  'test_setup_region.py',
  'test_vfu_create_ctx.py',
  'test_vfu_realize_ctx.py',
]

python_files = python_tests_common + python_tests

valgrind_python_args = [
  '--suppressions=' + (meson.current_source_dir() / 'valgrind.supp'),
  '--quiet',
  '--track-origins=yes',
  '--errors-for-leak-kinds=definite',
  '--show-leak-kinds=definite',
  '--leak-check=full',
  '--exit-on-first-error=yes',
  '--error-exitcode=1',
]

if pytest.found() and opt_sanitizers == 'none'
  foreach testname: python_tests
    test(testname,
         pytest,
         suite: 'python',
         env: environment({'LIBVFIO_SO_DIR': libvfio_so_dir}),
         args: [files(testname)])
  endforeach

  if opt_valgrind
    foreach testname: python_tests
      # serialize tests otherwise they hit the 30 sec timeout too easily
      test('valgrind-' + testname,
           valgrind,
           suite: 'valgrind',
           is_parallel : false,
           timeout: 120,
           env: environment({'PYTHONMALLOC': 'malloc',
                             'LIBVFIO_SO_DIR': libvfio_so_dir}),
           args: valgrind_python_args + [pytest.full_path(), files(testname)])
    endforeach
  endif

endif

if flake8.found()
  flake8_ignore = 'F405,F403,E128,E131,E127'
  test('flake8',
       flake8,
       suite: 'style',
       args: ['--extend-ignore', flake8_ignore,
              files(python_files)])
endif
