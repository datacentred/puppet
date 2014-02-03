# Definition: dc_collectd::virtual
# Virtual resource definitions below
#
class dc_collectd::virtual {
  define snmpvirtual (
    $host = undef,
    $ip = undef,
  ) {
    concat::fragment { "$title":
      target  => '/etc/collectd/conf.d/snmp.conf',
      content => template('dc_collectd/snmpconf_main.erb'),
    }
  }
}
