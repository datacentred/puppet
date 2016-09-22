# Class: dc_grub
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_grub {

  kernel_parameter { 'noplymouth':
    ensure => present,
  }

  # Since we don't use plymouth we don't need this
  # if it exists it will complain during boot
  file { '/etc/init/plymouth-upstart-bridge.conf':
    ensure => absent,
  }

}
