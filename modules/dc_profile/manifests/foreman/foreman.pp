# Class: dc_profile::foreman::foreman
#
# Provisions foreman with a database on another node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::foreman::foreman {

  include ::dc_foreman
  contain 'dc_foreman'

  class { '::foreman':
    foreman_url           => $::fqdn,
    authentication        => true,
    passenger             => true,
    use_vhost             => true,
    ssl                   => true,
  } -> Class['dc_foreman']

  package { 'foreman-compute':
    ensure  => installed,
    require => Class['::foreman'],
  }

  package { 'ruby-foreman-discovery':
    ensure  => installed,
    require => Class['::foreman'],
  }

  package { 'ruby-foreman-hooks':
    ensure  => installed,
    require => Class['::foreman'],
  }

  include dc_icinga::hostgroup_https
  include dc_icinga::hostgroup_foreman

}
