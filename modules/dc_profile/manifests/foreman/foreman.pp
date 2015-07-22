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

  class { '::foreman': }

  include foreman::plugin::discovery
  include foreman::plugin::digitalocean
  include foreman::plugin::hooks
  include foreman::plugin::puppetdb
  # TODO: this should probably have some deps and notifies between package
  #       and service will need testing when bringing up in CI
  # TODO: needs work on foreman to work properly - BRB!
  #include dc_foreman::ignored_environments

  package { 'foreman-cli':
    ensure => installed,
  }

  class { 'dc_foreman::hooks':
    require => Class['foreman::plugin::hooks'],
  }

  # TODO: Remove this if we ever introduce a second load-balanced
  # instance of Foreman
  @@dns_resource { "foreman.${::domain}/CNAME":
    rdata => $::fqdn,
  }

  include dc_icinga::hostgroup_https
  include dc_icinga::hostgroup_foreman

}
