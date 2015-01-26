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

  file { '/etc/default/grub':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_grub/grub',
  }

  # Since we don't use plymouth we don't need this
  # if it exists it will complain during boot
  file { '/etc/init/plymouth-upstart-bridge.conf':
    ensure => absent,
  }

  exec { '/usr/sbin/update-grub':
    refreshonly => true,
    subscribe   => File['/etc/default/grub'],
  }

}
