# Class: dc_profile::openstack::ceilometer_agent
#
# OpenStack Ceilometer - cloud utilisation and monitoring
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer_agent {

  $osapi_public = 'openstack.datacentred.io'

  $keystone_ceilometer_password = hiera(keystone_ceilometer_password)

  $os_region = hiera(os_region)

  class { '::ceilometer::agent::auth':
    auth_url      => "https://${osapi_public}:5000/v2.0",
    auth_user     => 'ceilometer',
    auth_password => $keystone_ceilometer_password,
    auth_region   => $os_region,
  }

  class { '::ceilometer::agent::compute': }

}
