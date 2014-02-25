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

  $foreman_pw = hiera(foreman_pw)

  class { '::foreman':
    foreman_url           => $::fqdn,
    authentication        => true,
    passenger             => true,
    use_vhost             => true,
    ssl                   => true,
    db_manage             => false,
    db_type               => 'postgresql',
    db_host               => 'db0.sal01.datacentred.co.uk',
    db_database           => 'foreman',
    db_username           => 'foreman',
    db_password           => $foreman_pw,
    oauth_active          => true,
    oauth_consumer_key    => 'you_shall_not_pass',
    oauth_consumer_secret => 't3H_84lr0G',
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_https']
  realize Dc_external_facts::Fact['dc_hostgroup_foreman']

}
