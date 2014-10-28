# Class: dc_profile::openstack::ceilometer
#
# OpenStack Ceilometer - cloud utilisation and monitoring
#
# Parameters:
#
# Actions:
#
# Requires: StackForge Ceilometer
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer {

  include ::ceilometer
  include ::ceilometer::api
  include ::ceilometer::agent::auth
  include ::ceilometer::agent::central
  include ::ceilometer::collector
  include ::ceilometer::expirer

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-ceilometer":
    listening_service => 'icehouse-ceilometer',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8777',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
