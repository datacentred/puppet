# == Class: dc_backups::duplicity_mariadb
#
# Backs up all the puppetcerts to swift_authversion
#
class dc_backup::duplicity_puppetcerts (
  $datacentred_swift_id = $dc_backup::params::datacentred_swift_id,
  $datacentred_swift_key = $dc_backup::params::datacentred_swift_key,
  $datacentred_swift_access_point = $dc_backup::params::datacentred_swift_access_point,
  $cloud = $dc_backup::params::cloud,
  $swift_authversion = $dc_backup::params::datacentred_swift_id,
) {

  package { 'python-swiftclient':
    ensure => installed,
  }

  duplicity { 'puppetcerts_to_swift':
    pre_command       => "tar zcf $backupdir/certs-$dateformat.tgz /var/lib/puppet/ssl >/dev/null 2>&1"
    directory         => '/var/certsbackup',
    bucket            => "puppetcerts_${::hostname}_backup",
    dest_id           => $datacentred_swift_id,
    dest_key          => $datacentred_swift_key,
    cloud             => $cloud, #which target we're writing to, S3, swift, rackspace etc
    swift_authurl     => $datacentred_swift_access_point,
    swift_authversion => $swift_authversion,
  }

}