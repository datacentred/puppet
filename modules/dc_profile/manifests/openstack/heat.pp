# Class: dc_profile::openstack::heat_db
#
# Openstack image API database definitions
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::heat {

  include ::heat
  include ::heat::engine
  include ::heat::api
  include ::heat::api_cfn

  @@haproxy::balancermember { "${::fqdn}-heat":
    listening_service => 'icehouse-heat',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8004',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  @@haproxy::balancermember { "${::fqdn}-heat-cfn":
    listening_service => 'icehouse-heat-cfn',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8000',
    options           => 'check inter 2000 rise 2 fall 5',
  }


}
