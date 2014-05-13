# Class: dc_collectd::poller
#
# Sets up the snmp collectd plugin to poll remote hosts
#
class dc_collectd::poller {

  $snmpconf = '/etc/collectd/conf.d/snmp.conf'

  concat { $snmpconf:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['collectd'],
  }

  concat::fragment { 'snmpconf_header':
    target  => $snmpconf,
    content => template('dc_collectd/poller/snmpconf_header.erb'),
    order   => '01',
  }

  concat::fragment { 'snmp_footer':
    target  => $snmpconf,
    content => "</Plugin>\n",
    order   => '999',
  }

  package { 'snmp-mibs-downloader':
    ensure => present,
  }

  package { 'snmp':
    ensure => present,
  }

  file { 'snmp.conf':
    path    => '/etc/snmp/snmp.conf',
    content => '',
    require => Package['snmp', 'snmp-mibs-downloader'],
  }

}
