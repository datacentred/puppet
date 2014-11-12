# Class: dc_profile::openstack::neutron_server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron_server {

  # Enable Neutron server services
  include ::neutron
  include ::neutron::server
  include ::neutron::plugins::ml2
  include ::neutron::notifications

  include dc_profile::auth::sudoers_neutron

  include dc_nrpe::neutron
  include dc_icinga::hostgroup_neutron_server

  # Add this node's API services into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-neutron":
    listening_service => 'icehouse-neutron',
    server_names      => $::hostname,
    ipaddresses       => $::fqdn,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
