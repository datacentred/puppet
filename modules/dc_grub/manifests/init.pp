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

  exec { '/usr/sbin/update-grub':
    refreshonly => true,
    subscribe   => File['/etc/default/grub'],
  }

}
