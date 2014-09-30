# Class: dc_profile::net::elasticsearch
#
# Configures elasticsearch
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
  $es_version,
  $cluster_name
  ) {

  class { '::elasticsearch':
    config       => { 'cluster.name' => $dc_profile::net::elasticsearch::cluster_name,
                      'network.host' => $::ipaddress },
    java_install => true,
  }

  elasticsearch::instance { 'es-01': }
}