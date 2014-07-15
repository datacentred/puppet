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

  $keystone_nova_password     = hiera(keystone_nova_password)
  $keystone_neutron_password  = hiera(keystone_neutron_password)

  $os_region                  = hiera(os_region)

  $nova_mq_username           = hiera(nova_mq_username)
  $nova_mq_password           = hiera(nova_mq_password)
  $rabbitmq_monuser           = hiera(rabbitmq_monuser)
  $rabbitmq_monuser_password  = hiera(rabbitmq_monuser_password)
  $nova_mq_port               = hiera(nova_mq_port)
  $nova_mq_vhost              = hiera(nova_mq_vhost)

  $nova_db_user               = hiera(nova_db_user)
  $nova_db_pass               = hiera(nova_db_pass)
  $nova_db_host               = hiera(nova_db_host)
  $nova_db                    = hiera(nova_db)

  $nova_admin_tenant          = hiera(nova_admin_tenant)
  $nova_admin_user            = hiera(nova_admin_user)
  $nova_enabled_apis          = hiera(nova_enabled_apis)

  $neutron_server_host        = hiera(neutron_server_host)
  $neutron_secret             = hiera(neutron_secret)
  $neutron_metadata_secret    = hiera(neutron_metadata_secret)

  # OpenStack API endpoint
  $osapi       = "osapi.${::domain}"

  $ec2_port = '8773'
  $nova_port = '8774'

  # Hard coded exported variable name
  $nova_mq_ev = 'nova_mq_node'

  $nova_database = "mysql://${nova_db_user}:${nova_db_pass}@${nova_db_host}/${nova_db}"

  $management_ip              = $::ipaddress_eth0

  class { '::nova':
    database_connection => $nova_database,
    glance_api_servers  => "http://${osapi}:9292",
    rabbit_hosts        => get_exported_var('', $nova_mq_ev, []),
    rabbit_userid       => $nova_mq_username,
    rabbit_password     => $nova_mq_password,
    rabbit_port         => $nova_mq_port,
    rabbit_virtual_host => $nova_mq_vhost,
    use_syslog          => true,
  }
  contain 'nova'

  class { '::nova::api':
    enabled                              => true,
    admin_tenant_name                    => $nova_admin_tenant,
    admin_user                           => $nova_admin_user,
    admin_password                       => $keystone_nova_password,
    enabled_apis                         => $nova_enabled_apis,
    auth_host                            => $osapi,
    auth_uri                             => "http://${osapi}:5000/v2.0",
    neutron_metadata_proxy_shared_secret => $neutron_metadata_secret,
  }
  contain 'nova::api'

  class { '::nova::network::neutron':
    neutron_url            => "http://${osapi}:9696",
    neutron_region_name    => $os_region,
    neutron_admin_auth_url => "http://${osapi}:35357/v2.0",
    neutron_admin_password => $keystone_neutron_password,
  }
  contain 'nova::network::neutron'

  class { [
    'nova::cert',
    'nova::conductor',
    'nova::consoleauth',
    'nova::scheduler',
    'nova::vncproxy'
  ]:
    enabled => true,
  }

  # Export variable for use by haproxy to front this
  # API endpoint
  exported_vars::set { 'nova_api':
    value => $::fqdn,
  }
  # Export variable for used by neutron
  exported_vars::set { 'nova_api_ip':
    value => $management_ip,
  }
  # Exported variable used by nova-compute
  exported_vars::set { 'novnc_proxy_host':
    value => $::fqdn,
  }

  @@keystone_endpoint { "${os_region}/nova":
    ensure        => present,
    public_url    => "http://${osapi}:${nova_port}/v2/%(tenant_id)s",
    admin_url     => "http://${osapi}:${nova_port}/v2/%(tenant_id)s",
    internal_url  => "http://${osapi}:${nova_port}/v2/%(tenant_id)s",
    tag           => 'nova_endpoint',
  }

  @@keystone_endpoint { "${os_region}/nova_ec2":
    ensure        => present,
    public_url    => "http://${osapi}:${ec2_port}/services/Cloud",
    admin_url     => "http://${osapi}:${ec2_port}/services/Admin",
    internal_url  => "http://${osapi}:${ec2_port}/services/Cloud",
    tag           => 'nova_endpoint',
  }

  # Nagios config
  include dc_profile::openstack::nova_nagios

  # Logstash config
  include dc_profile::openstack::nova_logstash

}
