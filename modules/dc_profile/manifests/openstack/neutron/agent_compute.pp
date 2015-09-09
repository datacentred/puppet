# Neutron agent configuration specific to compute nodes
class dc_profile::openstack::neutron::agent_compute {
  include ::neutron
  include ::neutron::plugins::ml2
  include ::neutron::agents::ml2::ovs

  # This doesn't need to run on compute nodes where we don't use
  # network namespaces.  This file is part of the neutron-common
  # package
  file { '/etc/cron.d/neutron-l3-agent-netns-cleanup':
    ensure => absent,
  }
}
