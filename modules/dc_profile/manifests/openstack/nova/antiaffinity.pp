# Class: dc_profile::openstack::nova::antiaffinity
#
# Deploys python lib to check anti-affinity rules
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova::antiaffinity {

  file { '/usr/local/lib/python2.7/dist-packages/antiaffinity.py':
    ensure => file,
    source => 'puppet:///modules/dc_openstack/antiaffinity.py'
  }

}
