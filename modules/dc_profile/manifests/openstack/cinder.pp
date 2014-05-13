# Class: dc_profile::openstack::cinder
#
# OpenStack Cinder - block storage service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::cinder {

  $keystone_host = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_cinder_password = hiera(keystone_cinder_password)

  $cinder_db        = hiera(cinder_db)
  $cinder_db_host   = hiera(cinder_db_host)
  $cinder_db_user   = hiera(cinder_db_user)
  $cinder_db_pass   = hiera(cinder_db_pass)

  $nova_mq_username   = hiera(nova_mq_username)
  $nova_mq_password   = hiera(nova_mq_password)
  $nova_mq_port       = hiera(nova_mq_port)
  $nova_mq_vhost      = hiera(nova_mq_vhost)

  $os_region = hiera(os_region)

  # Hard coded exported variable name
  $nova_mq_ev                 = 'nova_mq_node'

  $cinder_port = '8776'

  class {'::cinder':
    rpc_backend         => 'cinder.openstack.common.rpc.impl_kombu',
    sql_connection      => "mysql://${cinder_db_user}:${cinder_db_pass}@${cinder_db_host}/${cinder_db}?charset=utf8",
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_user         => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
    package_ensure      => present,
    enabled             => true,
  }

  class {'::cinder::api':
    keystone_enabled   => true,
    keystone_auth_host => "http://${keystone_host}:5000/v2.0",
    keystone_user      => 'cinder',
    keystone_password  => $keystone_cinder_password,
    use_syslog         => true,
    enabled            => true,
  }

  @@keystone_endpoint { "${os_region}/cinder":
    ensure       => present,
    public_url   => "http://${::fqdn}:${cinder_port}/v2",
    admin_url    => "http://${::fqdn}:${cinder_port}/v2",
    internal_url => "http://${::fqdn}:${cinder_port}/v2",
  }

  class {'::cinder::scheduler':
    scheduler_driver       => 'cinder.scheduler.simple.SimpleScheduler',
    package_ensure         => present,
    enabled                => true,
  }

  class {'::cinder::volume':
    package_ensure => present,
    enabled        => true,
  }

  # No RBD just yet! :(
  class { 'cinder::volume::iscsi':
    iscsi_ip_address => $::ipaddress_eth1,
    volume_group     => 'cindervg',
  }

  class { '::cinder::glance':
    glance_api_servers => get_exported_var('', 'glance_api_server', ['localhost'])
  }

}
