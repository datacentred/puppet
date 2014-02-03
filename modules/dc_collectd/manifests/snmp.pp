# Definition: dc_collectd::snmp
# Sets up the snmp collectd plugin to target hosts,
# specifically network devices in our case.
#
class dc_collectd::snmp {
  $snmpconf = '/etc/collectd/conf.d/snmp.conf'

  # Set up SNMP targets to be monitored
  include dc_collectd::snmptarget

  concat { $snmpconf:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service['collectd'],
  }

  concat::fragment { 'snmpconf_header':
    target  => $snmpconf,
    content => template('dc_collectd/snmpconf_header.erb'),
    order   => '01',
  }

  concat::fragment { 'snmp_footer':
    target  => $snmpconf,
    content => "</Plugin>\n",
    # This bit of configuration has to be the last line in the file
    order   => '999',
  }

  # Let's actually get some MIBS on the go
  package { 'snmp-mibs-downloader':
    ensure => latest,
  }

  file { 'snmp.conf':
    require => Package['snmp-mibs-downloader'],
    path   => '/etc/snmp/snmp.conf',
    # Default configuration has a single line that stops any MIBS
    # being loaded.  We want an empty file to ensure that's not
    # the case.
    content => '',
  }

}
