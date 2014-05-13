# Definition: dc_collectd::poller::snmp_target
#
# Create the appropriate configuration for collectd's
# snmp.conf for a given device
#
define dc_collectd::poller::snmp_target (
    $ip,
    $snmp_username,
    $snmp_auth_protocol,
    $snmp_auth_password,
    $snmp_privacy_protocol,
    $snmp_privacy_password,
    $interval = 60,
) {

  concat::fragment { $title:
    target  => '/etc/collectd/conf.d/snmp.conf',
    content => template('dc_collectd/poller/snmpconf_main.erb'),
  }

}
