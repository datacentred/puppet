# Class: dc_profile::openstack::nova
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova {

  include ::nova
  include ::nova::api
  include ::nova::network::neutron
  include ::nova::cert
  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::vncproxy
  include ::dc_icinga::hostgroup_nova_server

  nova_config { 'DEFAULT/default_floating_pool':
    value => 'external',
  }

  nova_config { 'DEFAULT/restrict_isolated_hosts_to_isolated_images':
    value => true,
  }

  # Add the various services from this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-compute":
    listening_service => 'nova-compute',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-metadata":
    listening_service => 'nova-metadata',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-novnc":
    listening_service => 'novncproxy',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '6080',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-ec2":
    listening_service => 'nova-ec2',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8773',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  unless $::is_vagrant {
    if $::environment == 'production' {
      include ::dc_logstash::client::nova
    }
  }

}
