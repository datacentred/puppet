# == Class: dc_postfix::client_sec
#
class dc_postfix::client_sec (
  $client_sec_config_hash,
){

  include ::dc_postfix

  $_sasl_user     = $::dc_postfix::sasl_user
  $_sasl_password = $::dc_postfix::sasl_password
  $_sasl_domain   = $::dc_postfix::sasl_domain
  $_relayhost     = $::dc_postfix::relayhost

  postfix::hash { '/etc/postfix/sasl_passwd':
    ensure  => present,
    content => template('dc_postfix/sasl_passwd.erb')
  }

  postfix::config { 'smtp_sasl_password_maps':
    value => 'hash:/etc/postfix/sasl_passwd',
  }

  create_resources( '::postfix::config', $client_sec_config_hash )

}
