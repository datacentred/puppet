# == Class: dpkg
#
# Manage debian's package manager
#
class dpkg (
  $multiarch_ensure = absent,
  $foreign_architectures = {},
) {

  # DEPRECATED
  file { '/etc/dpkg/dpkg.cfg.d/multiarch':
    ensure => $multiarch_ensure,
  }

  create_resources('dpkg::foreign_architecture', $foreign_architectures)

}
