# Class: dc_elasticsearch
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
class dc_elasticsearch::lbmember{
  @@haproxy::balancermember { "${::hostname}_elasticsearch":
    listening_service => 'elasticsearch',
    ipaddresses       => $::ipaddress,
    server_names      => $::hostname,
    ports             => '9200',
    options           => 'check',
  }
}