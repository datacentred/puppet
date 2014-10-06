# Class: dc_profile::log::logstash_lbmember
#
# Gives stats from loadbalancer members to haproxy for cluster management
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::logstash_lbmember{
  @@haproxy::balancermember { "${::hostname}_kibana":
    listening_service => 'kibana',
    ipaddresses       => $::ipaddress,
    server_names      => $::hostname,
    ports             => '80',
  }

  @@haproxy::balancermember { "${::hostname}_syslog":
    listening_service => 'syslog',
    ipaddresses       => $::ipaddress,
    server_names      => $::hostname,
    ports             => '5544',
  }

  @@haproxy::balancermember { "${::hostname}_forwarder":
    listening_service => 'forwarder',
    ipaddresses       => $::ipaddress,
    server_names      => $::hostname,
    ports             => '55515',
  }
}