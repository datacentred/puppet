# == Class: dc_backup::duplicity_dnsbackups
#
# Backs up dns records to swift
#
class dc_backup::duplicity_dnsbackups (
  $datacentred_swift_id = $dc_backup::params::datacentred_swift_id,
  $datacentred_swift_key = $dc_backup::params::datacentred_swift_key,
  $datacentred_swift_access_point = $dc_backup::params::datacentred_swift_access_point,
  $cloud = $dc_backup::params::cloud,
  $swift_authversion = $dc_backup::params::swift_authversion,
  $backup_source_dir,
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
    cloud             => $cloud, #which target we're writing to, S3, swift, rackspace etc
    swift_authurl     => $datacentred_swift_access_point,
    swift_authversion => $swift_authversion,
  }

}
