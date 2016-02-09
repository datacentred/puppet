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

  # FIXME create sasldb, chown to postfix

  runonce { 'sasl_db_create':
    command => "echo ${dc_postfix::sasl_password} | saslpasswd2 -c -u ${dc_postfix::sasl_domain} -a smtpauth ${dc_postfix::sasl_user} -p",
    require => Package['sasl2-bin'],
  }

  file { '/etc/sasldb2':
    ensure  => file,
    owner   => 'postfix',
    group   => 'root',
    mode    => '0660',
    require => Runonce['sasl_db_create'],
  }

}
