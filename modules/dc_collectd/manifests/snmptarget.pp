# Definition: dc_collectd::snmptarget
# Create the appropriate configuration for collectd's
# snmp.conf for a given device
#
define dc_collectd::snmptarget (
    $ip = undef,
) {

  $snmpcommunity = hiera(dc_snmp_community)

  concat::fragment { "$title":
    target  => '/etc/collectd/conf.d/snmp.conf',
    content => template('dc_collectd/snmpconf_main.erb'),
  }

}
