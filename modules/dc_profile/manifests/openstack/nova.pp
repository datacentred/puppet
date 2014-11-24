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
  include ::nova::vncproxy

  nova_config { 'default_floating_pool':
    value => 'ext-net',
  }

  include dc_profile::auth::sudoers_nova

  # Add the various services from this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-compute":
    listening_service => 'icehouse-nova-compute',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-metadata":
    listening_service => 'icehouse-nova-metadata',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-novnc":
    listening_service => 'icehouse-novncproxy',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '6080',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  include ::dc_nrpe::nova_server
  include ::dc_icinga::hostgroup_nova_server

  unless $::is_vagrant {
    if $::environment == 'production' {
      include dc_profile::openstack::nova_logstash
    }
  }

}
