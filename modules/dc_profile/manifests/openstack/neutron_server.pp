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

  $os_region          = hiera(os_region)

  $keystone_neutron_password = hiera(keystone_neutron_password)

  $nova_mq_username   = hiera(nova_mq_username)
  $nova_mq_password   = hiera(nova_mq_password)
  $nova_mq_port       = hiera(nova_mq_port)
  $nova_mq_vhost      = hiera(nova_mq_vhost)

  $neutron_secret     = hiera(neutron_secret)

  $neutron_db         = hiera(neutron_db)
  $neutron_db_host    = hiera(neutron_db_host)
  $neutron_db_user    = hiera(neutron_db_user)
  $neutron_db_pass    = hiera(neutron_db_pass)

  # Hard coded exported variable name
  $nova_mq_ev         = 'nova_mq_node'

  # OpenStack API endpoint
  $osapi_public  = 'openstack.datacentred.io'

  $neutron_port       = '9696'

  $management_ip      = $::ipaddress_eth0
  $integration_ip     = $::ipaddress_eth1

  # enable the neutron service
  class { 'neutron':
      enabled               => true,
      bind_host             => '0.0.0.0',
      rabbit_hosts          => get_exported_var('', $nova_mq_ev, []),
      rabbit_user           => $nova_mq_username,
      rabbit_password       => $nova_mq_password,
      rabbit_port           => $nova_mq_port,
      rabbit_virtual_host   => $nova_mq_vhost,
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
      database_max_pool_size => '30',
      mysql_module           => '2.2',
  }

  # Nagios stuff

  include dc_icinga::hostgroup_neutron_server

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

  # Export Keystone endpoint details
  # Might need revisiting once we have an external (public) network defined
  # TODO: SSL
  @@keystone_endpoint { "${os_region}/neutron":
    ensure       => present,
    public_url   => "https://${osapi_public}:${neutron_port}",
    admin_url    => "https://${osapi_public}:${neutron_port}",
    internal_url => "https://${osapi_public}:${neutron_port}",
    tag          => 'neutron_endpoint',
  }

}
