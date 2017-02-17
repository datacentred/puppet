# == Class: dc_profile::glance_meta
#
# Limits the editability of a certain image property only to users with administrator privileges
#
class dc_profile::openstack::glance_meta {

  #include glance::config

  file { '/usr/local/property_pr_rules':
    ensure  => present,
    content => file('dc_profile/property_pr_rules'),
  }

  glance_api_config { 'DEFAULT/property_protection_file' :
  value => '/usr/local/property_pr_rules',
  }

}
