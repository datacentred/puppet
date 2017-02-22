# == Class: dc_profile::glance_meta
#
# Limits the editability of a certain image property only to users with administrator privileges
# and adds a custom filter to nova scheduler
class dc_profile::openstack::glance_meta {

  file { '/usr/local/property_pr_rules':
    ensure  => present,
    content => file('dc_profile/property_pr_rules'),
  }

  glance_api_config { 'DEFAULT/property_protection_file' :
  value => '/usr/local/property_pr_rules',
  }

  file { '/usr/lib/python2.7/dist-packages/nova/scheduler/filters/aggregate_property_fixed.py':
    ensure  => present,
    content => file('dc_profile/aggregate_property_fixed.py'),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
  }

}
