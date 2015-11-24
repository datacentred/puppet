# Neutron agent configuration specific to network nodes
#
class dc_profile::openstack::neutron::agent_network {
  include ::neutron
  include ::neutron::plugins::ml2
  include ::neutron::agents::ml2::ovs
  include ::neutron::agents::dhcp
  include ::neutron::agents::vpnaas
  include ::neutron::agents::lbaas
  include ::neutron::agents::metadata
  include ::neutron::agents::metering
  include ::neutron::services::fwaas
  include ::collectd::plugin::protocols

  include ::sysctls

  $uplink_if = hiera(network_node_extif)

  # We want to disable GRO on the external interface
  # See: http://docs.openstack.org/havana/install-guide/install/apt/content/install-neutron.install-plug-in.ovs.html
  include ::ethtool
  ethtool { $uplink_if:
    gro => 'disabled',
  }

  # Set default domain
  neutron_dhcp_agent_config {
    'DEFAULT/dhcp_domain': value => 'datacentred.io';
  }

  # FIXME: Address shortcomings in the puppet-neutron module that
  # don't allow this to be configured by just including ::neutron::agents::l3
  neutron_l3_agent_config {
    'DEFAULT/allow_automatic_l3agent_failover': value => true;
    'DEFAULT/router_delete_namespaces':         value => true;
  }
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
      # Neutron module barfs if this doesn't exist.
      # It's usually created by the neutron-server package, which we
      # don't install on network nodes
      file { '/etc/default/neutron-server':
        ensure => present,
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
