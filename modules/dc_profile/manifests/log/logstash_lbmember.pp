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
  @@haproxy::balancermember { $dc_profile::log::logstash_lbmember::service_name:
    listening_service => $dc_profile::log::logstash_lbmember::service_name,
    ipaddresses       => $::ipaddress,
    server_names      => $::hostname,
    ports             => '9200,9300'

  }
}