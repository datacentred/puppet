# == Class: dc_ssl::slapd
#
class dc_ssl::slapd (
  $cert,
  $key,
) {

  File {
    owner => 'root',
    group => 'root',
  }

  file { '/etc/ssl/certs/slapd-server.crt':
    content => $cert,
    mode    => '0644',
  }

  file { '/etc/ssl/private/slapd-server.key':
    content => $key,
    mode    => '0600',
  }
}
