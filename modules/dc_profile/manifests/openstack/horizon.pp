# Class: dc_profile::openstack::horizon
#
# Class to deploy the OpenStack dashboard
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::horizon {

  include ::horizon
  include ::dc_branding::horizon

  Class['::horizon'] ->
  Class['::dc_branding::horizon']

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-horizon":
    listening_service => 'horizon',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  logrotate::rule { 'horizon':
    path          => '/var/log/horizon/*.log',
    rotate        => 90,
    rotate_every  => 'day',
    ifempty       => false,
    delaycompress => true,
    compress      => true,
    postrotate    => '/usr/sbin/service apache2 reload >/dev/null 2>/dev/null || true',
  }

}
