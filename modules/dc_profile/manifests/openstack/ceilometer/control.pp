# Class: dc_profile::openstack::ceilometer::control
#
# Main Ceilometer components for deployment on a cloud control node
#
# Parameters:
#
# Actions:
#
# Requires: StackForge Ceilometer
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer::control {

  include ::ceilometer
  include ::ceilometer::keystone::auth
  include ::ceilometer::api
  include ::ceilometer::agent::auth
  include ::ceilometer::agent::central
  include ::ceilometer::agent::notification
  include ::ceilometer::collector
  include ::ceilometer::expirer
  include ::ceilometer::db
  include ::ceilometer::alarm::evaluator
  include ::ceilometer::alarm::notifier

  ceilometer_config { 'database/use_tpool':
    value => true,
  }

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-ceilometer":
    listening_service => 'ceilometer',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8777',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
