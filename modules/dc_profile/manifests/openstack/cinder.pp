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

  $keystone_cinder_password = hiera(keystone_cinder_password)

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'openstack.datacentred.io'

  $cinder_db        = hiera(cinder_db)
  $cinder_db_host   = $osapi_public
  $cinder_db_user   = hiera(cinder_db_user)
  $cinder_db_pass   = hiera(cinder_db_pass)

  $rabbitmq_hosts    = hiera(osdbmq_members)
  $rabbitmq_username = hiera(rabbitmq_username)
  $rabbitmq_password = hiera(rabbitmq_password)
  $rabbitmq_port     = hiera(rabbitmq_port)
  $rabbitmq_vhost    = hiera(rabbitmq_vhost)

  $os_region = hiera(os_region)

  $cinder_port = '8776'

  include dc_profile::auth::sudoers_cinder

  class {'::cinder':
    rpc_backend         => 'cinder.openstack.common.rpc.impl_kombu',
    database_connection => "mysql://${cinder_db_user}:${cinder_db_pass}@${cinder_db_host}/${cinder_db}?charset=utf8",
    mysql_module        => '2.2',
    rabbit_hosts        => $rabbitmq_hosts,
    rabbit_userid       => $rabbitmq_username,
    rabbit_password     => $rabbitmq_password,
    rabbit_port         => $rabbitmq_port,
    rabbit_virtual_host => $rabbitmq_vhost,
    package_ensure      => present,
  }

  class {'::cinder::api':
    keystone_enabled       => true,
    keystone_auth_host     => $osapi_public,
    keystone_auth_protocol => 'https',
    keystone_user          => 'cinder',
    keystone_password      => $keystone_cinder_password,
    os_region_name         => $os_region,
    package_ensure         => present,
    enabled                => true,
  }

  @@keystone_endpoint { "${os_region}/cinder":
    ensure       => present,
    public_url   => "https://${osapi_public}:${cinder_port}/v1/%(tenant_id)s",
    admin_url    => "https://${osapi_public}:${cinder_port}/v1/%(tenant_id)s",
    internal_url => "https://${osapi_public}:${cinder_port}/v1/%(tenant_id)s",
    tag          => 'cinder_endpoint',
  }

  @@keystone_endpoint { "${os_region}/cinderv2":
    ensure       => present,
    public_url   => "https://${osapi_public}:${cinder_port}/v2/%(tenant_id)s",
    admin_url    => "https://${osapi_public}:${cinder_port}/v2/%(tenant_id)s",
    internal_url => "https://${osapi_public}:${cinder_port}/v2/%(tenant_id)s",
    tag          => 'cinder_endpoint',
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
  #class { 'cinder::volume::iscsi':
  #  iscsi_ip_address => $::ipaddress_eth1,
  #  volume_group     => 'cindervg',
  #}

  # Export variable for use by haproxy to front this
  # API endpoint
  exported_vars::set { 'cinder_api':
    value => $::fqdn,
  }

  class { '::cinder::glance':
    glance_api_servers => $osapi_public,
  }

  # Set default quotas
  # Set to 200GB temporarily until we have a larger backing store
  class { '::cinder::quota':
    quota_volumes   => '10',
    quota_snapshots => '10',
    quota_gigabytes => '200',
  }

  # Nagios config
  # include dc_profile::openstack::cinder_nagios

  # if $::environment == 'production' {
  #   # Logstash config
  #   include dc_profile::openstack::cinder_logstash
  # }

}
