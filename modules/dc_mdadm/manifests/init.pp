# Class: dc_mdadm
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
class dc_mdadm {

  file { '/etc/initramfs-tools/conf.d/mdadm':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_mdadm/mdadm',
  }

  exec { '/usr/sbin/update-initramfs':
    command     => '/usr/sbin/update-initramfs -u',
    refreshonly => true,
    subscribe   => File['/etc/initramfs-tools/conf.d/mdadm'],
  }

}
