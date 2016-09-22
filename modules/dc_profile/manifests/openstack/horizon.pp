# Class: dc_profile::openstack::horizon
#
# Class to deploy the OpenStack dashboard in a
# Docker container
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

  docker::run { 'horizon':
    image            => 'registry.datacentred.services:5000/horizon:mitaka',
    ports            => '80:80',
    extra_parameters => [ '--log-driver=syslog', '--log-opt syslog-address=udp://127.0.0.1:514',
                          '--log-opt syslog-facility=daemon', '--log-opt tag=horizon' ]
  }

  $_ipaddress = foreman_primary_ipaddress()

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-horizon":
    listening_service => 'horizon',
    server_names      => $::hostname,
    ipaddresses       => $_ipaddress,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

}
