# Class: dc_profile::openstack::ceilometer
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
class dc_profile::openstack::ceilometer {

  $ceilometer_secret = hiera(ceilometer_secret)
  $ceilometer_port = '8777'

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_ceilometer_password = hiera(keystone_ceilometer_password)

  $nova_mq_username   = hiera(nova_mq_username)
  $nova_mq_password   = hiera(nova_mq_password)
  $nova_mq_port       = hiera(nova_mq_port)
  $nova_mq_vhost      = hiera(nova_mq_vhost)

  $os_region = hiera(os_region)

  # Hard coded exported variable name
  $nova_mq_ev                 = 'nova_mq_node'

  # OpenStack API endpoint
  $osapi_public  = 'openstack.datacentred.io'

  class { '::ceilometer':
    metering_secret     => $ceilometer_secret,
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
  }

  class { '::ceilometer::api':
    keystone_host     => $keystone_host,
    keystone_protocol => 'https',
    keystone_user     => 'ceilometer',
    keystone_password => $keystone_ceilometer_password,
  }

  @@ceilometer_endpoint { "${os_region}/ceilometer":
    ensure       => present,
    public_url   => "https://${osapi_public}:${ceilometer_port}",
    admin_url    => "https://${osapi_public}:${ceilometer_port}",
    internal_url => "https://${osapi_public}:${ceilometer_port}",
    tag          => 'ceilometer_endpoint',
  }

}
