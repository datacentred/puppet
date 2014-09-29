# == Class: dc_ssl
#
class dc_ssl {
  file { '/etc/ssl/certs/datacentred-ca.pem':
    source => 'puppet:///modules/dc_ssl/ca.pem',
  }
}
