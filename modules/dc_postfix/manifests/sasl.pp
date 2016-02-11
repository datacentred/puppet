# == Class: dc_postfix::sasl
#
class dc_postfix::sasl {

  include ::sasl
  include ::dc_postfix

  ::sasl::application { 'smtpd':
    pwcheck_method => 'auxprop',
    auxprop_plugin => 'sasldb',
    mech_list      => ['digest-md5', 'cram-md5'],
  }

  $sasl_packages = [ 'sasl2-bin' ]

  ensure_packages( $sasl_packages )

  # Manage the postfix user and add it to the puppet group
  # so that postfix can use the puppet certs
  user { 'postfix':
    ensure  => present,
    groups  => [ 'puppet' ],
    require => Package['postfix'],
  }

  runonce { 'sasl_db_create':
    command => "echo ${dc_postfix::sasl_password} | saslpasswd2 -f ${dc_postfix::sasl_db} -c -u ${dc_postfix::sasl_domain} -a smtpauth ${dc_postfix::sasl_user} -p",
    require => Package['sasl2-bin'],
  }

  file { $dc_postfix::sasl_db :
    ensure  => file,
    owner   => 'postfix',
    group   => 'root',
    mode    => '0660',
    require => Runonce['sasl_db_create'],
  }

  create_resources ( postfix::config, $dc_postfix::gateway::sasl_config_hash )

}
