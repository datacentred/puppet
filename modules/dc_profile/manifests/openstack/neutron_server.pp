# Class: dc_profile::openstack::neutron_server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::neutron_server {

  $os_region = hiera(os_region)

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'openstack.datacentred.io'

  $keystone_neutron_password = hiera(keystone_neutron_password)

  $rabbitmq_hosts    = hiera(osdbmq_members)
  $rabbitmq_username = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password = hiera(osdbmq_rabbitmq_pass)
  $rabbitmq_port     = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost    = hiera(osdbmq_rabbitmq_vhost)

  $neutron_secret = hiera(neutron_secret)

  $neutron_db      = hiera(neutron_db)
  $neutron_db_host = $osapi_public
  $neutron_db_user = hiera(neutron_db_user)
  $neutron_db_pass = hiera(neutron_db_pass)

  $neutron_port       = '9696'

  $management_ip      = $::ipaddress_eth0
  $integration_ip     = $::ipaddress_eth1

  # enable the neutron service
  class { 'neutron':
      enabled               => true,
      bind_host             => '0.0.0.0',
      rabbit_hosts          => $rabbitmq_hosts,
      rabbit_user           => $rabbitmq_username,
      rabbit_password       => $rabbitmq_password,
      rabbit_port           => $rabbitmq_port,
      rabbit_virtual_host   => $rabbitmq_vhost,
      allow_overlapping_ips => true,
      verbose               => true,
      debug                 => false,
      core_plugin           => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      service_plugins       =>  [ 'neutron.services.vpn.plugin.VPNDriverPlugin',
                                  'neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
                                  'neutron.services.firewall.fwaas_plugin.FirewallPlugin',
                                  'neutron.services.metering.metering_plugin.MeteringPlugin',
                                ],
  }

  # configure authentication
  class { 'neutron::server':
      auth_host              => $osapi_public,
      auth_protocol          => 'https',
      auth_password          => $keystone_neutron_password,
      database_connection    => "mysql://${neutron_db_user}:${neutron_db_pass}@${neutron_db_host}/${neutron_db}?charset=utf8",
      database_max_pool_size => '50',
      mysql_module           => '2.2',
  }

  # Nagios stuff
  # include dc_icinga::hostgroup_neutron_server

  # Configure Neutron for OVS
  class { 'neutron::agents::ovs':
    local_ip         => $integration_ip,
    enable_tunneling => true,
  }

  # Enable the Open VSwitch plugin server
  class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
  }

  # Export variable for use by haproxy
  exported_vars::set { 'neutron_api':
    value => $::fqdn,
  }

  # Export endpoint details for Keystone
  @@keystone_endpoint { "${os_region}/neutron":
    ensure       => present,
    public_url   => "https://${osapi_public}:${neutron_port}",
    admin_url    => "https://${osapi_public}:${neutron_port}",
    internal_url => "https://${osapi_public}:${neutron_port}",
    tag          => 'neutron_endpoint',
  }

}
