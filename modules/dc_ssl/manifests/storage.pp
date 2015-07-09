# == Class: dc_ssl::storage
#
# Signed storage certificates and private keys for S3/Swift
#
class dc_ssl::storage (
  $cert,
  $key,
) {

  file { '/etc/ssl/certs/STAR_storage_datacentred_io.pem':
    content => $cert,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/ssl/private/STAR_storage_datacentred_io.key':
    content => $key,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }

}
