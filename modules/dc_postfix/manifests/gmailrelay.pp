# == Class: dc_postfix::gmailrelay
#
class dc_postfix::gmailrelay {

  create_resources ( postfix::config, $dc_postfix::gateway::smarthost_config_hash )

  $relayhost = $dc_postfix::gateway::smarthost_config_hash[relayhost][value]

  postfix::hash { '/etc/postfix/sasl_passwd':
    ensure  => present,
    content => "${relayhost} ${dc_postfix::gateway::smarthostuser}:${dc_postfix::gateway::smarthostpass}",
  }

}
