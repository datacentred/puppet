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

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $horizon_secret_key = hiera(horizon_secret_key)

  # OpenStack API endpoints
  $horizon_private = "horizon.${::domain}" 
  $osapi_public    = 'openstack.datacentred.io'

  class { '::horizon':
    fqdn                    => [$osapi_public, $horizon_private, $::fqdn],
    servername              => $osapi_public,
    secret_key              => $horizon_secret_key,
    keystone_url            => "https://${osapi_public}:5000/v2.0",
    keystone_default_role   => '_member_',
    django_debug            => true,
    api_result_limit        => 1000,
    neutron_options         => { 'enable_lb' => true, 'enable_vpn' => true },
  }
  contain 'horizon'

  class { '::dc_branding::openstack::horizon':
    require => Class['::horizon'],
  }
  contain 'dc_branding::openstack::horizon'

  # Export variable for use by haproxy
  exported_vars::set { 'horizon_host':
    value => $::fqdn,
  }

  # Logstash config
  if $::environment == 'production' {
    include dc_profile::openstack::horizon_logstash
  }

}
