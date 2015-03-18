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

  package { 'foreman-compute':
    ensure  => installed,
  }

  package { 'ruby-foreman-discovery':
    ensure  => installed,
  }

  package { 'ruby-foreman-puppetdb':
    ensure  => installed,
  }

  package { 'ruby-foreman-hooks':
    ensure  => installed,
  } ->
  class { 'dc_foreman::hooks': }

  package { 'ruby-foreman-digitalocean':
    ensure  => installed,
  }

  package { 'ruby-foreman-dhcp-browser':
    ensure  => installed,
  }

  package { 'foreman-cli':
    ensure  => installed,
  }

  # TODO: Remove this if we ever introduce a second load-balanced
  # instance of Foreman
  @@dns_resource { "foreman.${::domain}/CNAME":
    rdata => $::fqdn,
  }

  include dc_icinga::hostgroup_https
  include dc_icinga::hostgroup_foreman

  unless $::is_vagrant {
    if $::environment == 'production' {
      include ::dc_logstash::client::foreman
    }
  }

}
