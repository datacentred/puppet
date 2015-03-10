# == Class: dc_backups::duplicity_mariadb
#
# Backs up mariadb backups to swift
#
class dc_backup::duplicity_mariadb (
  $datacentred_swift_id = $dc_backup::params::datacentred_swift_id,
  $datacentred_swift_key = $dc_backup::params::datacentred_swift_key,
  $datacentred_swift_access_point = $dc_backup::params::datacentred_swift_access_point,
  $cloud = $dc_backup::params::cloud,
  $swift_authversion = $dc_backup::params::datacentred_swift_id,
) {

  package { 'python-swiftclient':
    ensure => installed,
  }

  duplicity { 'mariadb_to_swift':
    directory         => '/var/dbbackups',
    bucket            => "mariadb_${::hostname}_backup",
    dest_id           => $datacentred_swift_id,
    dest_key          => $datacentred_swift_key,
    cloud             => $cloud,
    swift_authurl     => $datacentred_swift_access_point,
    swift_authversion => $swift_authversion,
    remove_older_than => '1M',
  }

}