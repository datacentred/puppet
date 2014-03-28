# Class: dc_profile::openstack::neutron_agent
#
# Parameters: None
#
# Actions: Installs the OpenStack Neutron agent components
#
# Requires: neutron, vswitch
#
# Sample Usage:
#
class dc_profile::openstack::neutron_agent {
  $os_region          = hiera(os_region)

  $keystone_host      = get_exported_var('', 'keystone_host', ['localhost'])
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

  # Configure Neutron for OVS
  class { 'neutron::agents::ovs':
    local_ip         => $::network_eth1,
    enable_tunneling => true,
  }

  class { [
    'neutron::agents::dhcp',
    'neutron::agents::l3',
  ]:
    enabled => true,
  }
}

