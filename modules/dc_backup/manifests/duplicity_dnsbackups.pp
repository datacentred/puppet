# == Class: dc_backup::duplicity_mariadb
#
# Backs up all the puppetcerts to swift
#
class dc_backup::duplicity_dnsbackups (
  $datacentred_swift_id = $dc_backup::params::datacentred_swift_id,
  $datacentred_swift_key = $dc_backup::params::datacentred_swift_key,
  $datacentred_swift_access_point = $dc_backup::params::datacentred_swift_access_point,
  $cloud = $dc_backup::params::cloud,
  $swift_authversion = $dc_backup::params::datacentred_swift_id,
  $nameserver = $dc_backup::params::nameserver,
) {

  package { 'python-swiftclient':
    ensure => installed,
  }

  duplicity { 'dns_backups_to_swift':
    directory         => '/var/zonebackups',
    bucket            => "dns_${::hostname}_backup",
    dest_id           => $datacentred_swift_id,
    dest_key          => $datacentred_swift_key,
    cloud             => $cloud, #which target we're writing to, S3, swift, rackspace etc
    swift_authurl     => $datacentred_swift_access_point,
    swift_authversion => $swift_authversion,
  }

}
