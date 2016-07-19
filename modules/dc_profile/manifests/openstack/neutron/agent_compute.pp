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
    tunnel_types         => [ 'gre' ],
    arp_responder        => true,
    prevent_arp_spoofing => false,
  }

  # This doesn't need to run on compute nodes where we don't use
  # network namespaces.  This file is part of the neutron-common
  # package
  file { '/etc/cron.d/neutron-l3-agent-netns-cleanup':
    ensure => absent,
  }

  unless $::osfamily == 'Debian' {
    # Due to a packaging bug on RedHat, the Open vSwitch agent initialization
    # script explicitly looks for the Open vSwitch plug-in configuration file
    # rather than a symbolic link /etc/neutron/plugin.ini pointing to the ML2
    # plug-in configuration file.
    file_line { 'neutron-ovs-agent-systemd':
      path    => '/usr/lib/systemd/system/neutron-openvswitch-agent.service',
      line    => 'ExecStart=/usr/bin/neutron-openvswitch-agent --config-file /usr/share/neutron/neutron-dist.conf --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini --config-dir /etc/neutron/conf.d/common --config-dir /etc/neutron/conf.d/neutron-openvswitch-agent --log-file /var/log/neutron/openvswitch-agent.log',
      match   => '^ExecStart',
      require => Package['openstack-neutron-openvswitch'],
    }
  }

}
