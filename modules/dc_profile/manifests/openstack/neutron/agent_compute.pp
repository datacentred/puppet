# == Class: ::dc_profile::openstack::network::agent_compute
#
# Neutron agent configuration specific to compute nodes
#
class dc_profile::openstack::neutron::agent_compute {
  include ::neutron
  include ::neutron::plugins::ml2

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling     => true,
    local_ip             => values(netip('ark-compute-integration', hiera(networks))),
    arp_responder        => true,
    prevent_arp_spoofing => false,
  }

  # This doesn't need to run on compute nodes where we don't use
  # network namespaces.  This file is part of the neutron-common
  # package
  file { '/etc/cron.d/neutron-l3-agent-netns-cleanup':
    ensure => absent,
  }
}
