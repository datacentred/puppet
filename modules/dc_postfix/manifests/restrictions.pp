# == Class: dc_postfix::restrictions
#
class dc_postfix::restrictions {

  $external_sysmail_split = split($dc_postfix::gateway::external_sysmail_address, '@')
  $external_mail_domain   = $external_sysmail_split[1]

  postfix::config { 'relay_domains':
    value => $external_mail_domain
  }

  create_resources ( postfix::config, $dc_postfix::gateway::restrictions_config_hash )

}

