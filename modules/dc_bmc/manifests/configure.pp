# == Class: dc_bmc::configure
#
# Configures IPMI services
#
class dc_bmc::configure {

  file { '/etc/default/ipmievd':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_bmc/ipmievd.default',
  }

}
