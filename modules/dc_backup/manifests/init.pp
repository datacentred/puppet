# == Class: dc_backup
#
# Pulls in all the bits of data we need from hiera and set some sensible defaults
#
class dc_backup (
  $datacentred_ceph_access_key,
  $datacentred_ceph_secret_key,
  $datacentred_ceph_access_point,
  $datacentred_amazon_s3_id,
  $datacentred_amazon_s3_key,
  $datacentred_signing_key_public,
  $datacentred_signing_key_private,
  $datacentred_signing_key_short_id,
  $datacentred_signing_key_finger,
  $datacentred_encryption_key_public,
  $datacentred_encryption_key_short_id,
  $datacentred_encryption_key_finger,
  $datacentred_encryption_key_private,
  $datacentred_private_signing_key_password,
  $datacentred_private_encryption_key_password,
) {

  include ::dc_backup::gpg_keys

  tidy { 'duplicity_signature_cache':
    path    => '/root/.cache/duplicity/',
    age     => '30d',
    recurse => true,
    rmdirs  => true,
  }

  Class['::dc_backup'] -> Dc_backup::Dc_duplicity_job <||>

}
