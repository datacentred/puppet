# Class: dc_pcs::netservices::loopback
#
# Configure net services loopback devices for drdb
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
class dc_pcs::netservices::loopback {

  file { $dc_pcs::netservices::loopback_store :
    ensure => directory,
    notify  => Exec['net_services_zero']
  }

  exec { 'net_services_zero':
    command     => "dd if=/dev/zero of=$dc_pcs::netservices::loopback_store/net_services.img bs=1 count=0 seek=1000M",
    timeout     => '1000',
    refreshonly => true,
    require     => File[$dc_pcs::netservices::loopback_store],
  }

  file { '/etc/init.d/drbd_lofs_netservices':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('dc_pcs/drbd_lofs_netservices.erb'),
  }

  runonce { 'update_rcd_lofs':
    command    => 'update-rc.d drbd_lofs_netservices defaults',
    persistent => true,
    require    => File['/etc/init.d/drbd_lofs_netservices'],
  }

  runonce { 'drbd_lofs':
    command    => '/etc/init.d/drbd_lofs_netservices start',
    persistent => true,
    require    => [ File['/etc/init.d/drbd_lofs_netservices'], Exec['net_services_zero'] ],
  }

}
