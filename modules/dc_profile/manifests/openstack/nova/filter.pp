# == Class: dc_profile::openstack::nova::filter
#
# Adds a custom filter to nova scheduler
#
class dc_profile::openstack::nova::filter {

  file { '/usr/lib/python2.7/dist-packages/nova/scheduler/filters/aggregate_property_fixed.py':
    ensure  => present,
    content => file('dc_profile/aggregate_property_fixed.py'),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
  }

  # It should be possible to put the filter in a different folder and map that
  # to the filter section in nova.conf
  #  file { '/usr/local/filters':
  #    ensure => directory,
  #  }
  #
  #  file_line { 'Add PYTHONPATH to /etc/profile':
  #    path => '/etc/profile',
  #    line => 'PYTHONPATH=/usr/local/filters/',
  #}

}
