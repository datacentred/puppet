class dc_apparmor::dhcpd {

  file { '/etc/apparmor.d/local/usr.sbin.dhcpd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => "capability dac_override,\n",
    notify  => [ Service['apparmor'], Service['isc-dhcp-server']],
  }

}
