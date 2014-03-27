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

  $keystone_host      = get_exported_var('', 'keystone_host', ['localhost'])

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
  $nova_mq_ev = 'nova_mq_node'

  $neutron_port = "9696"

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
  }
  
  # configure authentication
  class { 'neutron::server':
      auth_host           => $keystone_host,
      auth_password       => $keystone_neutron_password,
      database_connection => "mysql://${neutron_db_user}:${neutron_db_pass}@${neutron_db_host}/${neutron_db}?charset=utf8",
      mysql_module        => '2.2',
  }

  # Configure Neutron for OVS
  class { 'neutron::agents::ovs':
    local_ip         => $::network_eth1,
    enable_tunneling => true,
  }

  # Enable the Open VSwitch plugin server
  class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
  } 

  # Export Keystone endpoint details
  # Might need revisiting once we have an external (public) network defined
  @@keystone_endpoint { "${os_region}/neutron":
    ensure       => present,
    public_url   => "http://${::fqdn}:${neutron_port}",
    admin_url    => "http://${::fqdn}:${neutron_port}",
    internal_url => "http://${::fqdn}-int:${neutron_port}",
    tag          => 'neutron_endpoint',
  }

}
