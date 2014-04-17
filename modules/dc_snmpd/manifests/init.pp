class dc_snmpd (
  $dc_snmp_community = hiera(dc_snmp_community),
  $snmp_allowed_net  = hiera(snmp_allowed_net),
  $system_location   = hiera(system_location),
  $sysadmin_email    = hiera(sal01_internal_sysmail_address),
){

  package { 'snmpd':
    ensure  => installed,
    require => Package['snmp-mibs-downloader']
  }

  package { 'snmp-mibs-downloader':
    ensure  => installed,
  }

  service {'snmpd':
    ensure    => running,
    enable    => true,
    require   => [ File['/etc/snmp/snmpd.conf'], File['/etc/default/snmpd'], File['/etc/snmp/snmp.conf'], Package['snmp-mibs-downloader'] ],
    subscribe => [ File['/etc/snmp/snmpd.conf'], File['/etc/default/snmpd'], File['/etc/snmp/snmp.conf'] ]
  }

  file {'/etc/snmp/snmpd.conf':
    path    => '/etc/snmp/snmpd.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['snmpd'],
    content => template('dc_snmpd/snmpd.conf.erb'),
  }

  file {'/etc/default/snmpd':
    path    => '/etc/default/snmpd',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['snmpd'],
    source  => 'puppet:///modules/dc_snmpd/snmpd',
  }

  file {'/etc/snmp/snmp.conf':
    path    => '/etc/snmp/snmp.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['snmpd'],
    source  => 'puppet:///modules/dc_snmpd/snmp.conf',
  }
}
