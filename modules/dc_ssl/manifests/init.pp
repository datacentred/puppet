class dc_ssl {
  file { '/etc/ssl/certs/datacentred-ca.pem':
    source => 'puppet:///modules/dc_ssl/ca.pem',
  }
}