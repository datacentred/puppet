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
    $graphs = [],
) {

  include stdlib

  # Create the collectd SNMP host object
  concat::fragment { $title:
    target  => '/etc/collectd/conf.d/snmp.conf',
    content => template('dc_collectd/poller/snmpconf_main.erb'),
  }

  # Ensure graphs is always an array and pass through bracket expansion
  $_graphs = any2array($graphs)
  $_expanded_graphs = bracket_expansion($graphs)

  # Extract a hostname from the title field
  $namearray = split($title, '.')
  $_hostname = $namearray[-1]
  # Format a reversed domain string to use in templates
  $reversedomain = join(delete_at($namearray,-1),'.')
  # Add hostname to the array of interfaces
  $ifhashhost = suffix($_expanded_graphs, "#${_hostname}")

  # Now export virtual resource for network traffic for each
  # interface
  @@dc_gdash::swnettraf { $ifhashhost:
    reversedomain => $reversedomain
  }

}
