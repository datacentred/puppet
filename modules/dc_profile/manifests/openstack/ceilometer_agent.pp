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

  $nova_mq_username   = hiera(nova_mq_username)
  $nova_mq_password   = hiera(nova_mq_password)
  $nova_mq_port       = hiera(nova_mq_port)
  $nova_mq_vhost      = hiera(nova_mq_vhost)

  $ceilometer_secret = hiera(ceilometer_secret)

  $os_region = hiera(os_region)

  # Hard coded exported variable name
  $nova_mq_ev = 'nova_mq_node'

  class { '::ceilometer':
    metering_secret     => $ceilometer_secret,
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
  }

  class { '::ceilometer::agent::auth':
    auth_url      => "https://${osapi_public}:5000/v2.0",
    auth_user     => 'ceilometer',
    auth_password => $keystone_ceilometer_password,
    auth_region   => $os_region,
  }

  class { '::ceilometer::agent::compute': }

}
