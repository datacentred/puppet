# Class: dc_profile::openstack::neutron_agent
#
# Parameters: Checks for network_node set at global scope
# for hosts in the OpenStack/Network Host Group
#
# Actions: Installs the OpenStack Neutron agent components
#
# Requires: neutron, vswitch
#
# Sample Usage:
#
class dc_profile::openstack::neutron_agent {
  $os_region                  = hiera(os_region)

  $keystone_host              = get_exported_var('', 'keystone_host', ['localhost'])
  $keystone_neutron_password  = hiera(keystone_neutron_password)

  $nova_api_ip                = get_exported_var('', 'nova_api_ip', ['localhost'])
  $nova_mq_username           = hiera(nova_mq_username)
  $nova_mq_password           = hiera(nova_mq_password)
  $nova_mq_port               = hiera(nova_mq_port)
  $nova_mq_vhost              = hiera(nova_mq_vhost)

  $neutron_secret             = hiera(neutron_secret)
  $neutron_metadata_secret    = hiera(neutron_metadata_secret)

  $neutron_db                 = hiera(neutron_db)
  $neutron_db_host            = hiera(neutron_db_host)
  $neutron_db_user            = hiera(neutron_db_user)
  $neutron_db_pass            = hiera(neutron_db_pass)

  # Hard coded exported variable name
  $nova_mq_ev                 = 'nova_mq_node'

  $neutron_port               = '9696'

  $management_ip              = $::ipaddress_eth0
  $integration_ip             = $::ipaddress_eth1

  # Physical interface plumbed into external network
  $uplink_if                  = 'eth2'

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

  # If we're on a designated network node, configure the various
  # additional Neutron agents for L3, DHCP and metadata functionality
  # Note: network_node is defined at Host Group level via Foreman
  if $::network_node {
    class { 'neutron::agents::ovs':
      bridge_uplinks        => ["br-ex:${uplink_if}"],
      bridge_mappings       => ['default:br-ex'],
      local_ip              => $integration_ip,
      enable_tunneling      => true,
    }

    class { 'neutron::agents::dhcp':
      enabled => true,
    }

    class { 'neutron::agents::l3':
      enabled                  => true,
      use_namespaces           => true,
      router_delete_namespaces => true,
      interface_driver         => 'neutron.agent.linux.interface.OVSInterfaceDriver',
    }

    class { 'neutron::agents::metadata':
      shared_secret => $neutron_metadata_secret,
      auth_url      => "http://${keystone_host}:35357/v2.0",
      auth_password => $keystone_neutron_password,
      auth_region   => $os_region,
      metadata_ip   => $nova_api_ip,
    }

    class { 'neutron::agents::vpnaas':
      enabled          => true,
    }

    class { 'neutron::agents::lbaas':
      enabled        => true,
      use_namespaces => true,
    }

    class { 'neutron::agents::metering':
      enabled        => true,
      use_namespaces => true,
    }

  }
  else  {
    # We're a compute node, so just configure the OVS basics
    class { 'neutron::agents::ovs':
      local_ip         => $integration_ip,
      enable_tunneling => true,
    }

    file { '/etc/nagios/nrpe.d/os_neutron_agent.cfg':
      ensure  => file,
      content => 'command[check_neutron_agent]=/usr/lib/nagios/plugins/check_procs -c 1 -u neutron -a neutron-openvswitch-agent',
    }
  }

  # Nagios checks common to both network and compute node
  file { '/etc/nagios/nrpe.d/os_ovswitch_proc.cfg':
    ensure  => file,
    content => 'command[check_ovswitch_proc]=/usr/lib/nagios/plugins/check_procs -w 2: -C ovs-vswitchd',
  }

  file { '/etc/nagios/nrpe.d/os_ovswitch_server_proc.cfg':
    ensure  => file,
    content => 'command[check_ovswitch_server_proc]=/usr/lib/nagios/plugins/check_procs -w 2: -C ovsdb-server',
  }
}
