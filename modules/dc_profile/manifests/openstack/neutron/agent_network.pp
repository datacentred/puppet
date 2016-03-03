# Neutron agent configuration specific to network nodes
#
class dc_profile::openstack::neutron::agent_network {
  include ::neutron
  include ::neutron::plugins::ml2
  include ::neutron::agents::ml2::ovs
  include ::neutron::agents::l3
  include ::neutron::agents::dhcp
  include ::neutron::agents::vpnaas
  include ::neutron::agents::lbaas
  include ::neutron::agents::metadata
  include ::neutron::agents::metering
  include ::neutron::services::fwaas

  include ::sysctls

  $uplink_if = hiera(network_node_extif)

  # We want to disable GRO on the external interface
  # See: http://docs.openstack.org/havana/install-guide/install/apt/content/install-neutron.install-plug-in.ovs.html
  include ::ethtool
  ethtool { $uplink_if:
    gro => 'disabled',
  }

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
