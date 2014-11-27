# == Class: dc_ssl::storage
#
# Signed storage certificates and private keys for S3/Swift
#
class dc_ssl::storage {

  file { '/etc/ssl/certs/STAR_storage_datacentred_io.pem':
    source => 'puppet:///modules/dc_ssl/storage/STAR_storage_datacentred_io.pem',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/ssl/private/STAR_storage_datacentred_io.key':
    source => 'puppet:///modules/dc_ssl/storage/STAR_storage_datacentred_io.key',
    owner  => 'root',
    group  => 'root',
    mode   => '0400',
  }

}
