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
  $osapi_public  = 'compute.datacentred.io'

  $cinder_db        = hiera(cinder_db)
  $cinder_db_host   = $osapi_public
  $cinder_db_user   = hiera(cinder_db_user)
  $cinder_db_pass   = hiera(cinder_db_pass)

  $rabbitmq_hosts    = hiera(osdbmq_members)
  $rabbitmq_username = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password = hiera(osdbmq_rabbitmq_pw)
  $rabbitmq_port     = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost    = hiera(osdbmq_rabbitmq_vhost)

  $os_region = hiera(os_region)

  $management_ip = $::ipaddress

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

  class {'::cinder::scheduler':
    scheduler_driver       => 'cinder.scheduler.simple.SimpleScheduler',
    package_ensure         => present,
    enabled                => true,
  }

  class {'::cinder::volume':
    package_ensure => present,
    enabled        => true,
  }

  class { '::cinder::glance':
    glance_api_servers => $osapi_public,
  }

  # Add this node into our loadbalancer
  @@haproxy::balancermember { "${::fqdn}-cinder":
    listening_service => 'icehouse-cinder',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '8776',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  # Set default quotas
  # Set to 200GB temporarily until we have a larger backing store
  class { '::cinder::quota':
    quota_volumes   => '10',
    quota_snapshots => '10',
    quota_gigabytes => '200',
  }

  # Nagios config
  include dc_profile::openstack::cinder_nagios

  if $::environment == 'production' {
    # Logstash config
    include dc_profile::openstack::cinder_logstash
  }

}
