# Class: dc_profile::openstack::nova::control
#
# OpenStack Nova control components profile class
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova::control {

  include ::nova
  include ::nova::keystone::auth
  include ::nova::api
  include ::nova::network::neutron
  include ::nova::cert
  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::vncproxy
  include ::dc_icinga::hostgroup_nova_server

  nova_config { 'DEFAULT/restrict_isolated_hosts_to_isolated_images':
    value => true,
  }

  # TODO: Use the actual ::nova::api parameter once we've upgraded puppet-nova
  nova_config { 'DEFAULT/secure_proxy_ssl_header':
    value => 'X-Forwarded-Proto',
  }

  $_ipaddress = foreman_primary_ipaddress()

  # Add the various services from this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-compute":
    listening_service => 'nova-compute',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-metadata":
    listening_service => 'nova-metadata',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-novnc":
    listening_service => 'novncproxy',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '6080',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-ec2":
    listening_service => 'nova-ec2',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '8773',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
