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

  class { '::foreman':
    foreman_url           => $::fqdn,
    authentication        => true,
    passenger             => true,
    use_vhost             => true,
    ssl                   => true,
  }

  include dc_icinga::hostgroups
  class { '::foreman':} ->
  class { 'dc_foreman': }
  realize Dc_external_facts::Fact['dc_hostgroup_https']
  realize Dc_external_facts::Fact['dc_hostgroup_foreman']

}
