# == Class: ::dc_profile::openstack::neutron::agent_network
#
# Neutron agent configuration specific to network nodes
#
class dc_profile::openstack::neutron::agent_network {
  include ::neutron
  include ::neutron::plugins::ml2
  include ::neutron::agents::l3
  include ::neutron::agents::dhcp
  include ::neutron::agents::vpnaas
  include ::neutron::agents::lbaas
  include ::neutron::agents::metadata
  include ::neutron::agents::metering
  include ::neutron::services::fwaas

  include ::sysctls

  $uplink_if = hiera(network_node_extif)

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling     => true,
    bridge_mappings      => [ 'default:br-ex', "as201541:br-${uplink_if}" ],
    bridge_uplinks       => [ 'br-ex:em2', "br-${uplink_if}:${uplink_if}" ],
    tunnel_types         => [ 'gre' ],
    local_ip             => values(netip('ark-compute-integration', hiera(networks))),
    arp_responder        => true,
    prevent_arp_spoofing => false,
  }
    
  # We want to disable GRO on the external interface
  # See: http://docs.openstack.org/havana/install-guide/install/apt/content/install-neutron.install-plug-in.ovs.html
  include ::ethtool
  ethtool { $uplink_if:
    gro => 'disabled',
  }

  # Required for L3-HA
  ensure_packages(['keepalived'])

  # FIXME: Workaround for the way in which the puppet-neutron module handles services
  file { '/etc/init.d/neutron-l3-agent':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root'
  }

  # Workaround for the fact that we're using the Neutron VPN agent, which
  # handles L3 instead of the vanilla Neutron L3 agent.  The current
  # puppet-neutron module doesn't handle this properly.
  Neutron_l3_agent_config<||> ~> Service['neutron-vpnaas-service']

  # Distribution-specific hacks^Wconsiderations
  case $::osfamily {
    'Debian': {
      augeas { $uplink_if:
        context => '/files/etc/network/interfaces',
        changes => [
            "set iface[. = '${uplink_if}'] ${uplink_if}",
            "set iface[. = '${uplink_if}']/family inet",
            "set iface[. = '${uplink_if}']/method manual",
            "set iface[. = '${uplink_if}'] ${uplink_if}",
            # Now set via DHCP
            "rm iface[. = '${uplink_if}']/pre-up 'ip link set ${uplink_if} mtu 9000'",
            "set iface[. = '${uplink_if}']/up 'ip link set dev ${uplink_if} up'",
            "set iface[. = '${uplink_if}']/down 'ip link set dev ${uplink_if} down'",
        ],
      }
    }
    'RedHat': {
      service { 'firewalld':
        ensure => 'stopped',
      }
      service { 'NetworkManager':
        ensure => 'stopped',
      }
    }
    default: {}
  }
}
