# == Class: dc_ssl::slapd
#
class dc_ssl::slapd {

  file { '/etc/ssl/certs/slapd-server.crt':
    source => 'puppet:///modules/dc_ssl/slapd/slapd-server.crt',
  }

  file { '/etc/ssl/private/slapd-server.key':
    source => 'puppet:///modules/dc_ssl/slapd/slapd-server.key',
  }
}
