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
#use exported resources from dc_profile to get all the ports and names set up?
#might have to blend exported with data that doesn't change for each one
#have a think.
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