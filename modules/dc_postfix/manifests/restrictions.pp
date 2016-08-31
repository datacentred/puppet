# == Class: dc_postfix::restrictions
#
class dc_postfix::restrictions {

  include ::dc_postfix::gateway

  $alias_domains = $::dc_postfix::gateway::alias_domains

  postfix::hash { '/etc/postfix/relaydomains':
    ensure    => present,
    map_owner => 'postfix',
    content   => template('dc_postfix/relaydomains.erb'),
  }

  create_resources ( postfix::config, $dc_postfix::gateway::restrictions_config_hash )

}

