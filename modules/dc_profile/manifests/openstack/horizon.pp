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

  $horizon_secret_key = hiera(horizon_secret_key)

  # OpenStack API endpoints
  $horizon_private = "horizon.${::domain}"
  $osapi_public    = 'compute.datacentred.io'

  $management_ip = $::ipaddress

  class { '::horizon':
    fqdn                  => [$osapi_public, $horizon_private, $::fqdn],
    servername            => $osapi_public,
    secret_key            => $horizon_secret_key,
    keystone_url          => "https://${osapi_public}:5000/v2.0",
    keystone_default_role => '_member_',
    django_debug          => true,
    api_result_limit      => 1000,
    neutron_options       => { 'enable_firewall' => true,
                               'enable_lb'       => true,
                               'enable_vpn'      => true,
                             }, 
  }

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-horizon":
    listening_service => 'icehouse-horizon',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '80',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  if $::environment == 'production' {
    # Logstash config
    include dc_profile::openstack::horizon_logstash
  }

}
