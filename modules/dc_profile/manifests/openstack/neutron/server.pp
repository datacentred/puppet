# Class: dc_profile::openstack::neutron::server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron::server {

  include ::neutron
  include ::neutron::keystone::auth
  include ::neutron::server
  include ::neutron::server::notifications
  include ::neutron::plugins::ml2
  include ::neutron::quota
  include ::dc_icinga::hostgroup_neutron_server

  ensure_packages( ['python-neutron-vpnaas', 'python-neutron-lbaas'] )

  # Add this node's API services into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-neutron":
    listening_service => 'neutron',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
