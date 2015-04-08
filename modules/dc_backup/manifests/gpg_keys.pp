# == Class: dc_backup::gpg_keys
#
# Sets up gpg signing and encryption keys on nodes with backups
#
class dc_backup::gpg_keys (
  $datacentred_signing_key_public,
  $datacentred_signing_key_private,
  $datacentred_signing_key_short_id,
  $datacentred_signing_key_finger,
  $datacentred_encryption_key_public,
  $datacentred_encryption_key_short_id,
  $datacentred_encryption_key_finger,
) inherits dc_backup::params {

  include ::gnupg
  $trust_level = ':6:'

  gnupg_key { 'datacentred_public_signing_key':
    ensure      => present,
    key_id      => $datacentred_signing_key_short_id,
    user        => 'root',
    key_content => $datacentred_signing_key_public,
    key_type    => public,
  }

  gnupg_key { 'datacentred_private_signing_key':
    ensure      => present,
    key_id      => $datacentred_signing_key_short_id,
    user        => 'root',
    key_content => $datacentred_signing_key_private,
    key_type    => private,
  }

  gnupg_key { 'datacentred_public_encryption_key':
    ensure      => present,
    key_id      => $datacentred_encryption_key_short_id,
    user        => 'root',
    key_content => $datacentred_encryption_key_public,
    key_type    => public,
  }

  exec { 'do_you_want_to_build_a_trustdb':
    command => "echo ${datacentred_signing_key_finger}${trust_level} > /tmp/${datacentred_signing_key_finger}.keyid; echo ${datacentred_encryption_key_finger}${trust_level} > /tmp/${datacentred_encryption_key_finger}.keyid; gpg --import-ownertrust /tmp/${datacentred_signing_key_finger}.keyid; gpg --import-ownertrust /tmp/${datacentred_encryption_key_finger}.keyid",
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user    => 'root',
  }

}