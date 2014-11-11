# Class: dc_profile::openstack::nova
#
# Nova controller node
# As a starter for 10 ;-) it fits the bill, I do however think in time
# this could be split up into a more modular rather than monolithic
# blob dependent on what our use case turns out to be - SM
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova {

  $keystone_nova_password    = hiera(keystone_nova_password)
  $keystone_neutron_password = hiera(keystone_neutron_password)

  $os_region = hiera(os_region)

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'compute.datacentred.io'

  $osdbmq_members            = hiera(osdbmq_members)

  $rabbitmq_username         = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password         = hiera(osdbmq_rabbitmq_pw)
  $rabbitmq_monuser          = hiera(rabbitmq_monuser)
  $rabbitmq_monuser_password = hiera(rabbitmq_monuser_password)
  $rabbitmq_port             = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost            = hiera(osdbmq_rabbitmq_vhost)

  $nova_db_user = hiera(nova_db_user)
  $nova_db_pass = hiera(nova_db_pass)
  $nova_db_host = $osapi_public
  $nova_db      = hiera(nova_db)

  $nova_admin_tenant = hiera(nova_admin_tenant)
  $nova_admin_user   = hiera(nova_admin_user)
  $nova_enabled_apis = hiera(nova_enabled_apis)

  $neutron_server_host     = hiera(neutron_server_host)
  $neutron_secret          = hiera(neutron_secret)
  $neutron_metadata_secret = hiera(neutron_metadata_secret)

  $nova_database = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

  $management_ip = $::ipaddress

  class { '::nova':
    database_connection => $nova_database,
    glance_api_servers  => "https://${osapi_public}:9292",
    rabbit_hosts        => $osdbmq_members,
    rabbit_userid       => $rabbitmq_username,
    rabbit_password     => $rabbitmq_password,
    rabbit_port         => $rabbitmq_port,
    rabbit_virtual_host => $rabbitmq_vhost,
    memcached_servers   => $osdbmq_members,
    use_syslog          => true,
  }

  include dc_profile::auth::sudoers_nova

  class { '::nova::api':
    enabled                              => true,
    admin_tenant_name                    => $nova_admin_tenant,
    admin_user                           => $nova_admin_user,
    admin_password                       => $keystone_nova_password,
    enabled_apis                         => $nova_enabled_apis,
    auth_host                            => $osapi_public,
    auth_protocol                        => 'https',
    auth_uri                             => "https://${osapi_public}:5000/v2.0",
    neutron_metadata_proxy_shared_secret => $neutron_metadata_secret,
  }

  class { '::nova::network::neutron':
    neutron_url            => "https://${osapi_public}:9696",
    neutron_region_name    => $os_region,
    neutron_admin_auth_url => "https://${osapi_public}:35357/v2.0",
    neutron_admin_password => $keystone_neutron_password,
  }

  class { [
    '::nova::cert',
    '::nova::conductor',
    '::nova::consoleauth',
    '::nova::scheduler',
    '::nova::vncproxy'
  ]:
    enabled => true,
  }

  # Add the various services from this node into our loadbalancers
  @@haproxy::balancermember { "${::fqdn}-compute":
    listening_service => 'icehouse-nova-compute',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '8774',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-metadata":
    listening_service => 'icehouse-nova-metadata',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '8775',
    options           => 'check inter 2000 rise 2 fall 5',
  }
  @@haproxy::balancermember { "${::fqdn}-novnc":
    listening_service => 'icehouse-novncproxy',
    server_names      => $::hostname,
    ipaddresses       => $management_ip,
    ports             => '6080',
    options           => 'check inter 2000 rise 2 fall 5',
  }

  include ::dc_nrpe::nova_server
  include ::dc_icinga::hostgroup_nova_server

  unless $::is_vagrant {
    if $::environment == 'production' {
      include dc_profile::openstack::nova_logstash
    }
  }

}
