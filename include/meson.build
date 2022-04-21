
public_include_dir = [include_directories('.')]

libvfio_user_includes = files(
  'libvfio-user.h',
  'pci_defs.h',
  'vfio-user.h'
)

install_headers(
  libvfio_user_includes,
  install_dir: includedir / 'vfio-user'
)

subdir('pci_caps')
