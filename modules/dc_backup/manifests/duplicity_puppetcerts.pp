# == Class: dc_backups::duplicity_puppetcerts
#
# Backs up all the puppetcerts to swift and (encrypted) to S3
#
class dc_backup::duplicity_puppetcerts (
  $datacentred_swift_id = $dc_backup::params::datacentred_swift_id,
  $datacentred_swift_key = $dc_backup::params::datacentred_swift_key,
  $datacentred_swift_access_point = $dc_backup::params::datacentred_swift_access_point,
  $swift_authversion = $dc_backup::params::swift_authversion,
  $backup_source_dir,
  $datacentred_amazon_s3_id = $dc_backup::params::datacentred_amazon_s3_id,
  $datacentred_amazon_s3_key = $dc_backup::params::datacentred_amazon_s3_key,
  $datacentred_encryption_key_short_id = $dc_backup::params::datacentred_encryption_key_short_id,
  $datacentred_signing_key_short_id = $dc_backup::params::datacentred_signing_key_short_id,
) inherits dc_backup::params {

  package { 'python-swiftclient':
    ensure => installed,
  }

  exec { 'puppetcerts_backups_swift_container':
    command => "swift --os-username=${datacentred_swift_id} --os-password=${datacentred_swift_key} --os-auth-url=${datacentred_swift_access_point} post datacentred_puppetcerts_${::hostname}_backup",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }->

  duplicity { 'puppetcerts_to_swift':
    directory         => $backup_source_dir,
    bucket            => "datacentred_puppetcerts_${::hostname}_backup",
    dest_id           => $datacentred_swift_id,
    dest_key          => $datacentred_swift_key,
    cloud             => 'swift',
    swift_authurl     => $datacentred_swift_access_point,
    swift_authversion => $swift_authversion,
    remove_older_than => '1M',
  }

  duplicity { 'puppetcerts_to_amazon_s3':
    directory          => $backup_source_dir,
    bucket             => 'datacentred',
    dest_id            => $datacentred_amazon_s3_id,
    dest_key           => $datacentred_amazon_s3_key,
    cloud              => 's3',
    remove_older_than  => '1M',
    folder             => "puppetcerts_${::hostname}_backup",
    encrypt_key_id     => $datacentred_encryption_key_short_id,
    sign_key_id        => $datacentred_signing_key_short_id,
  }

}