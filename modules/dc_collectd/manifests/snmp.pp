class dc_collectd::snmp {
  $snmpconf = '/etc/collectd/conf.d/snmp.conf'

  concat { $snmpconf:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  concat::fragment { 'snmpconf_header':
    target  => $snmpconf,
    content => template('dc_collectd/snmpconf_header.erb'),
    order   => '01',
  }

  concat::fragment { 'snmp_footer':
    target  => $snmpconf,
    content => "</Plugin>\n",
    # We want this to be last, regardless of how many times we
    # realise snmptarget_query (up to a sane limit!)
    order   => '999',
  }

  define snmptarget_query ($host,$ip,$snmpconf) {
    concat::fragment { "$title":
      target  => "$snmpconf",
      content => template('dc_collectd/snmpconf_main.erb'),
    }
  }

  @snmptarget_query { 'sg300':
    snmpconf => $snmpconf,
    host     => '10.10.10.2',
    ip       => '10.10.10.2',
  }

  @snmptarget_query { '3560g':
    snmpconf => $snmpconf,
    host     => 'ark-rack3-3560g-top',
    ip       => '10.10.32.2',
  }
  
  Snmptarget_query <| |>
}
