# == Class: dc_postfix::restrictions
#
class dc_postfix::restrictions {

  postfix::hash { '/etc/postfix/relaydomains':
    ensure    => present,
    map_owner => 'postfix',
    content   => "/^.*\.${dc_postfix::gateway::top_level_domain}$/ OK",
  }

  create_resources ( postfix::config, $dc_postfix::gateway::restrictions_config_hash )

}

