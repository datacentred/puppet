# == Class: dc_backup::duplicity_dnsbackups
#
# Backs up dns records to swift
#
class dc_backup::duplicity_dnsbackups (
  $datacentred_swift_id = $dc_backup::params::datacentred_swift_id,
  $datacentred_swift_key = $dc_backup::params::datacentred_swift_key,
  $datacentred_swift_access_point = $dc_backup::params::datacentred_swift_access_point,
  $swift_authversion = $dc_backup::params::swift_authversion,
  $backup_source_dir,
  $datacentred_amazon_s3_id = $dc_backup::params::datacentred_amazon_s3_id,
  $datacentred_amazon_s3_key = $dc_backup::params::datacentred_amazon_s3_key,
  $datacentred_backup_encryption_pubkey = $dc_backup::params::datacentred_backup_encryption_pubkey,
) inherits dc_backup::params {

  package { 'python-swiftclient':
    ensure => installed,
  }

  exec { 'dns_backups_container':
    command => "swift --os-username=${datacentred_swift_id} --os-password=${datacentred_swift_key} --os-auth-url=${datacentred_swift_access_point} post datacentred_dns_${::hostname}_backup",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
  }->

  duplicity { 'dns_backups_to_swift':
    directory         => $backup_source_dir,
    bucket            => "datacentred_dns_${::hostname}_backup",
    dest_id           => $datacentred_swift_id,
    dest_key          => $datacentred_swift_key,
    cloud             => 'swift',
    swift_authurl     => $datacentred_swift_access_point,
    swift_authversion => $swift_authversion,
  }

  duplicity { 'dns_backups_to_amazon_s3':
    directory         => $backup_source_dir,
    bucket            => "datacentred_dns_${::hostname}_backup",
    dest_id           => $datacentred_amazon_s3_id,
    dest_key          => $datacentred_amazon_s3_key,
    cloud             => 's3',
    remove_older_than => '1M',
    pubkey_id         => $datacentred_backup_encryption_pubkey,
  }

}
