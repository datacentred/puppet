class dc_snmpd (
  $dc_snmp_community = hiera(dc_snmp_community),
  $snmp_allowed_net  = hiera(snmp_allowed_net),
  $system_location   = hiera(system_location),
  $sysadmin_email    = hiera(sysadmin_email),
){

  package { 'snmpd':
    ensure    => installed,
  }

  service {'snmpd':
    ensure  => running,
    enable  => true,
    require => File['/etc/snmp/snmpd.conf'],
  }

  file {'/etc/snmp/snmpd.conf':
    path    => '/etc/snmp/snmpd.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['snmpd'],
    content => template('dc_snmpd/snmpd.conf.erb'),
    notify  => Service['snmpd']
  }

  file {'/etc/default/snmpd':
    path    => '/etc/default/snmpd',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['snmpd'],
    content => template('dc_snmpd/snmpd.default.erb'),
    notify  => Service['snmpd'],
  }
}
