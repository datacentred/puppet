# Definition: dc_backup::dc_duplicity_job
#
# This class sets up duplicity backup jobs
#
# Parameters:
# - The $cloud to backup to
# - The $pre_command to run before backups
# - The $backup_content describing what service we're backing up
# - The $source_dir to backup from
#
# Sample Usage:
#  dc_backup::dc_duplicity_job { '${::hostname}':
#    cloud          => 's3',
#    backup_content => 'mariadb',
#    source_dir     => '/var/backups/',
#  }
#
define dc_backup::dc_duplicity_job(
  $backup_content,
  $source_dir,
  $pre_command = undef,
  $cloud = 'all',
  $datacentred_ceph_access_key = $dc_backup::params::datacentred_ceph_access_key,
  $datacentred_ceph_secret_key = $dc_backup::params::datacentred_ceph_secret_key,
  $datacentred_ceph_access_point = $dc_backup::params::datacentred_ceph_access_point,
  $swift_authversion = $dc_backup::params::swift_authversion,
  $datacentred_amazon_s3_id = $dc_backup::params::datacentred_amazon_s3_id,
  $datacentred_amazon_s3_key = $dc_backup::params::datacentred_amazon_s3_key,
  $datacentred_encryption_key_short_id = $dc_backup::params::datacentred_encryption_key_short_id,
  $datacentred_signing_key_short_id = $dc_backup::params::datacentred_signing_key_short_id,
  $datacentred_private_signing_key_password = $dc_backup::params::datacentred_private_signing_key_password,
  $datacentred_private_encryption_key_password = $dc_backup::params::datacentred_private_encryption_key_password,
) {

  $ensure_dc_ceph = $cloud ? {
    /(dc_ceph|all)/ => present,
    default         => absent,
  }

  $ensure_s3 = $cloud ? {
    /(s3|all)/ => present,
    default    => absent,
  }

  duplicity { 'datacentred_ceph':
    ensure          => $ensure_dc_ceph,
    directory       => $source_dir,
    dest_id         => $datacentred_ceph_access_key,
    dest_key        => $datacentred_ceph_secret_key,
    cloud           => 's3',
    custom_endpoint => "s3://${datacentred_ceph_access_point}/datacentred/${backup_content}_${::hostname}_backup/"
  }


  duplicity { 'amazon_s3':
    ensure                 => $ensure_s3,
    pre_command            => $pre_command,
    directory              => $source_dir,
    bucket                 => 'datacentred',
    dest_id                => $datacentred_amazon_s3_id,
    dest_key               => $datacentred_amazon_s3_key,
    sign_key_passphrase    => $datacentred_private_signing_key_password,
    encrypt_key_passphrase => $datacentred_private_encryption_key_password,
    cloud                  => 's3',
    remove_older_than      => '1M',
    folder                 => "${backup_content}_${::hostname}_backup",
    encrypt_key_id         => $datacentred_encryption_key_short_id,
    sign_key_id            => $datacentred_signing_key_short_id,
  }

}