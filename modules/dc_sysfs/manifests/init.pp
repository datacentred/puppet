# == Class: ds_sysfs
#
# Replaces the package's default init script to support the status command thus making puppet idempotent.
#
class dc_sysfs {

  include ::sysfs

  Package['sysfsutils'] ->

  file { '/etc/init.d/sysfsutils':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_sysfs/sysfsutils',
  } ->

  Service['sysfsutils']
}
