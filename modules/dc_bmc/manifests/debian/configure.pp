# == Class: dc_bmc::debian::configure
#
# Configures IPMI services
#
class dc_bmc::debian::configure {

  file { '/etc/default/ipmievd':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_bmc/ipmievd.default',
  }

}
