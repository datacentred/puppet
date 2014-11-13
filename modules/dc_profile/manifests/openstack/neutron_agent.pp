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

  # Top-level Neutron configuration common to all
  include ::neutron
  include ::neutron::plugins::ml2
  include ::neutron::agents::ml2::ovs

  include dc_nrpe::neutron_agent

  # A bug in the ML2 plugin deployment means that this file needs to be
  # present
  file { '/etc/default/neutron-server':
    ensure  => present,
  }

  # We also need conntrack - it's a missing dependancy for the neutron
  # packages
  package { 'conntrack':
    ensure => installed,
  }

  include dc_profile::auth::sudoers_neutron

  # If we're on a designated network node, configure the various
  # additional Neutron agents for L3, DHCP and metadata functionality
  # Note: network_node is defined at Host Group level via Foreman
  if $::network_node {
    # We want to disable GRO on the external interface
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

    include ::neutron::agents::dhcp
    include ::neutron::agents::vpnaas
    include ::neutron::agents::lbaas
    include ::neutron::agents::metadata

  }

}
