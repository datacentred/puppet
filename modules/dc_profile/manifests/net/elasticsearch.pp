# Class: dc_profile::net::elasticsearch
#
# Configures elasticsearch and runs one instance
#
# Parameters:
#
# Actions:
#
# Requires: puppet-elasticsearch
#
# Sample Usage:
#
class dc_profile::net::elasticsearch(
  $cluster_name,
) {

  class { '::elasticsearch':
    config       => { 'cluster.name' => $cluster_name,
                      'network.host' => $::ipaddress },
    java_install => true,
  }

  elasticsearch::instance { 'es-01': }
}