# Class: dc_profile::openstack::ceilometer::agent
#
# Ceilometer agent components for deployment on compute
# and network nodes.
#
# Parameters:
#
# Actions:
#
# Requires: StackForge Ceilometer
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer::agent {

  include ::ceilometer
  include ::ceilometer::agent::auth
  include ::ceilometer::agent::compute

  # Disable disk checking due to https://bugs.launchpad.net/ceilometer/+bug/1457440
  file { '/etc/ceilometer/pipeline.yaml':
    ensure  => file,
    source  => 'puppet:///modules/dc_openstack/pipeline.yaml',
    require => Class['::ceilometer'],
    notify  => Service['ceilometer-agent-compute'],
  }

}
