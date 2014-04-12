class dc_postfix::gmailrelay {

  $smart_host = hiera(smarthost)
  $smarthost_user = hiera(smarthostuser)
  $smarthost_pass = hiera(smarthostpass)

  postfix::config { 'relayhost':
    value => "[${smart_host}]:587",
  }
  postfix::config { 'smtp_use_tls':
    value => 'yes',
  }
  postfix::config { 'smtp_sasl_auth_enable':
    value => 'yes',
  }
  postfix::hash { '/etc/postfix/sasl_passwd':
    ensure  => present,
    content => "[${smart_host}]:587  ${smarthost_user}:${smarthost_pass}",
  }
  postfix::config { 'smtp_sasl_password_maps':
    value => 'hash:/etc/postfix/sasl_passwd',
  }
  postfix::config { 'smtp_tls_CAfile':
    value => '/etc/ssl/certs/ca-certificates.crt',
  }
  postfix::config { 'smtp_sasl_security_options':
    ensure => 'blank',
  }

}
