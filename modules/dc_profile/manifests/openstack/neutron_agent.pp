# Class: dc_profile::openstack::neutron_agent
#
# Parameters: Checks for network_node set at global scope
# for hosts in the OpenStack/Network Host Group
#
# Actions: Installs the OpenStack Neutron agent components
#
# Requires: neutron, vswitch, ethtool, puppet-network
#
# Sample Usage:
#
class dc_profile::openstack::neutron_agent {
  $os_region = hiera(os_region)

  # OpenStack API and loadbalancer endpoint
  $osapi_public  = 'compute.datacentred.io'

  $keystone_neutron_password = hiera(keystone_neutron_password)

  $rabbitmq_hosts    = hiera(osdbmq_members)
  $rabbitmq_username = hiera(osdbmq_rabbitmq_user)
  $rabbitmq_password = hiera(osdbmq_rabbitmq_pw)
  $rabbitmq_port     = hiera(osdbmq_rabbitmq_port)
  $rabbitmq_vhost    = hiera(osdbmq_rabbitmq_vhost)

  $neutron_secret          = hiera(neutron_secret)
  $neutron_metadata_secret = hiera(neutron_metadata_secret)

  $neutron_db      = hiera(neutron_db)
  $neutron_db_host = $osapi_public
  $neutron_db_user = hiera(neutron_db_user)
  $neutron_db_pass = hiera(neutron_db_pass)

  $neutron_port = '9696'

  $management_ip  = $::ipaddress

  package { 'neutron-plugin-openvswitch':
    ensure => installed,
  }

  class { '::neutron':
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
    require               => Package['neutron-plugin-openvswitch'],
  }

  include dc_profile::auth::sudoers_neutron

  # If we're on a designated network node, configure the various
  # additional Neutron agents for L3, DHCP and metadata functionality
  # Note: network_node is defined at Host Group level via Foreman
  if $::network_node {

    $integration_ip = $::ipaddress_p2p1

    # We also want to disable GRO on the external interface
    # See: http://docs.openstack.org/havana/install-guide/install/apt/content/install-neutron.install-plug-in.ovs.html
    # Physical interface plumbed into external network
    $uplink_if = 'em2'
    include ethtool
    ethtool { $uplink_if:
      gro => 'disabled',
    }

    # Ensure configuration is in place so that the external (bridged)
    # is actually brought up at boot
    augeas { $uplink_if:
      context => '/files/etc/network/interfaces',
      changes => [
          "set iface[. = '${uplink_if}'] ${uplink_if}",
          "set iface[. = '${uplink_if}']/family inet",
          "set iface[. = '${uplink_if}']/method manual",
          "set iface[. = '${uplink_if}'] ${uplink_if}",
          "set iface[. = '${uplink_if}']/up 'ip link set dev ${uplink_if} up'",
          "set iface[. = '${uplink_if}']/down 'ip link set dev ${uplink_if} down'",
      ],
    }

    class { 'neutron::agents::ovs':
      bridge_uplinks    => ["br-ex:${uplink_if}"],
      bridge_mappings   => ['default:br-ex'],
      local_ip          => $integration_ip,
      enable_tunneling  => true,
    }

    class { 'neutron::agents::dhcp':
      enabled     => true,
    }

    class { 'neutron::agents::l3':
      enabled                  => true,
      use_namespaces           => true,
      router_delete_namespaces => true,
    }

    class { 'neutron::agents::metadata':
      shared_secret => $neutron_metadata_secret,
      auth_url      => "https://${osapi_public}:35357/v2.0",
      auth_password => $keystone_neutron_password,
      auth_region   => $os_region,
      metadata_ip   => get_ip_addr($osapi_public),
    }

    class { 'neutron::agents::vpnaas':
      enabled => true,
    }

    class { 'neutron::agents::lbaas':
      enabled        => true,
      use_namespaces => true,
    }

#    class { 'neutron::agents::metering':
#      enabled        => true,
#      use_namespaces => true,
#    }
  }
  else  {

    # We're a compute node
    $integration_ip = $::ipaddress_p1p1

    class { 'neutron::agents::ovs':
      local_ip         => $integration_ip,
      enable_tunneling => true,
    }
  }

#     if $::environment == 'production' {
#
#       file { '/etc/nagios/nrpe.d/os_neutron_dhcp_agent.cfg':
#         ensure  => present,
#         content => 'command[check_neutron_dhcp_agent]=/usr/lib/nagios/plugins/check_procs -c 1: -u neutron -a /usr/bin/neutron-dhcp-agent',
#         require => Package['nagios-nrpe-server'],
#         notify  => Service['nagios-nrpe-server'],
#       }
#
#       file { '/etc/nagios/nrpe.d/os_neutron_l3_agent.cfg':
#         ensure  => present,
#         content => 'command[check_neutron_l3_agent]=/usr/lib/nagios/plugins/check_procs -c 1: -u neutron -a /usr/bin/neutron-l3-agent',
#         require => Package['nagios-nrpe-server'],
#         notify  => Service['nagios-nrpe-server'],
#       }
#
#       file { '/etc/nagios/nrpe.d/os_neutron_metadata_agent.cfg':
#         ensure  => present,
#         content => 'command[check_neutron_metadata_agent]=/usr/lib/nagios/plugins/check_procs -c 1: -a /usr/bin/neutron-ns-metadata-proxy',
#         require => Package['nagios-nrpe-server'],
#         notify  => Service['nagios-nrpe-server'],
#       }
#
#       file { '/etc/nagios/nrpe.d/os_neutron_vpn_agent.cfg':
#         ensure  => present,
#         content => 'command[check_neutron_vpn_agent]=/usr/lib/nagios/plugins/check_procs -c 1: -u neutron -a /usr/bin/neutron-vpn-agent',
#         require => Package['nagios-nrpe-server'],
#         notify  => Service['nagios-nrpe-server'],
#       }
#
#       file { '/etc/nagios/nrpe.d/os_neutron_lbaas_agent.cfg':
#         ensure  => present,
#         content => 'command[check_neutron_lbaas_agent]=/usr/lib/nagios/plugins/check_procs -c 1: -u neutron -a /usr/bin/neutron-lbaas-agent',
#         require => Package['nagios-nrpe-server'],
#         notify  => Service['nagios-nrpe-server'],
#       }
#
#       file { '/etc/nagios/nrpe.d/os_neutron_metering_agent.cfg':
#         ensure  => present,
#         content => 'command[check_neutron_metering_agent]=/usr/lib/nagios/plugins/check_procs -c 1: -u neutron -a /usr/bin/neutron-metering-agent',
#         require => Package['nagios-nrpe-server'],
#         notify  => Service['nagios-nrpe-server'],
#       }
#     }

}
