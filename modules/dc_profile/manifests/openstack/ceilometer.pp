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

  $ceilometer_db      = hiera(ceilometer_db)
  $ceilometer_db_user = hiera(ceilometer_db_user)
  $ceilometer_db_pass = hiera(ceilometer_db_pass)
  $ceilometer_db_host = hiera(ceilometer_db_host)

  $nova_mq_username   = hiera(nova_mq_username)
  $nova_mq_password   = hiera(nova_mq_password)
  $nova_mq_port       = hiera(nova_mq_port)
  $nova_mq_vhost      = hiera(nova_mq_vhost)

  $os_region = hiera(os_region)

  # Hard coded exported variable name
  $nova_mq_ev = 'nova_mq_node'

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

  class { '::ceilometer::db':
    database_connection  => "mysql://${ceilometer_db_user}:${ceilometer_db_pass}@${ceilometer_db_host}/${ceilometer_db}",
    require              => Dc_mariadb::Db[$ceilometer_db]
  }

  class { '::ceilometer::api':
    keystone_host     => $keystone_host,
    keystone_protocol => 'https',
    keystone_user     => 'ceilometer',
    keystone_password => $keystone_ceilometer_password,
  }

  # Export variable for use by haproxy to front this
  # API endpoint
  exported_vars::set { 'ceilometer_api':
    value => $::fqdn,
  }

  class { '::ceilometer::agent::auth':
    auth_url      => "https://${osapi_public}:5000/v2.0",
    auth_user     => 'ceilometer',
    auth_password => $keystone_ceilometer_password,
    auth_region   => $os_region,
  }

  class { '::ceilometer::agent::central': }

  class { '::ceilometer::collector': }

  # Purge 1 month old meters
  class { '::ceilometer::expirer':
    time_to_live => '2592000'
  }

  # Virtual resource for the Keystone API endpoint creation
  @@keystone_endpoint { "${os_region}/ceilometer":
    ensure       => present,
    public_url   => "https://${osapi_public}:${ceilometer_port}",
    admin_url    => "https://${osapi_public}:${ceilometer_port}",
    internal_url => "https://${osapi_public}:${ceilometer_port}",
    tag          => 'ceilometer_endpoint',
  }

}
