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

  include dc_icinga::hostgroups
  realize External_facts::Fact['dc_hostgroup_https']
  realize External_facts::Fact['dc_hostgroup_foreman']

}
