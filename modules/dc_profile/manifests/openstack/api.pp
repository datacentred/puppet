# Class: dc_profile::openstack::api
#
# OpenStack Front-End API server
#
# Parameters:
#
# Actions:
#
# Requires: datacentred-haproxy, with dev version of haproxy that
#           includes SSL support
#
# Sample Usage:
#

class dc_profile::openstack::api {

  class { 'haproxy': }

  haproxy::listen { [ 'keystone', 'horizon', 'glance-api',
                      'glance-reg', 'neutron', 'nova-compute',
                      'nova-metadata', 'cinder']:
    ipaddress => $::ipaddress,
    ports     => '5000',
    ssl       => '/etc/haproxy/test.pem',
    options   =>  {
                    'option'  => ['tcpka', 'httpchk', 'tcplog'],
                    'balance' => 'source',
                  }
  }

  haproxy::balancermember { 'keystone':
    listening_service => 'keystone',
    server_names      => 'controller0.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '5000',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'horizon':
    listening_service => 'horizon',
    server_names      => 'controller0.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'glance-api':
    listening_service => 'glance-api',
    server_names      => 'controller0.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '9292',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'glance-reg':
    listening_service => 'glance-reg',
    server_names      => 'controller0.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '9191',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'neutron':
    listening_service => 'neutron',
    server_names      => 'controller1.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '9696',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'nova-compute':
    listening_service => 'nova-compute',
    server_names      => 'controller1.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'nova-metadata':
    listening_service => 'nova-metadata',
    server_names      => 'controller1.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  haproxy::balancermember { 'cinder':
    listening_service => 'cinder',
    server_names      => 'controller1.sal01.datacentred.co.uk',
    ipaddresses       => '10.10.160.161',
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }
}
