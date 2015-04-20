# == Class: dc_backup::gpg_keys
#
# Sets up gpg signing and encryption keys on nodes with backups
#
class dc_backup::gpg_keys (
  $datacentred_signing_key_public,
  $datacentred_signing_key_private,
  $datacentred_signing_key_short_id = $dc_backup::params::datacentred_signing_key_short_id,
  $datacentred_signing_key_finger,
  $datacentred_encryption_key_public,
  $datacentred_encryption_key_short_id = $dc_backup::params::datacentred_encryption_key_short_id,
  $datacentred_encryption_key_finger,
  $datacentred_encryption_key_private,
) inherits dc_backup::params {

  contain gnupg

  gnupg_key { 'datacentred_public_signing_key':
    ensure      => present,
    key_id      => $datacentred_signing_key_short_id,
    user        => 'root',
    key_content => $datacentred_signing_key_public,
    key_type    => public,
    trust_level => '6',
  }

  gnupg_key { 'datacentred_private_signing_key':
    ensure      => present,
    key_id      => $datacentred_signing_key_short_id,
    user        => 'root',
    key_content => $datacentred_signing_key_private,
    key_type    => private,
    trust_level => '6',
  }

  gnupg_key { 'datacentred_public_encryption_key':
    ensure      => present,
    key_id      => $datacentred_encryption_key_short_id,
    user        => 'root',
    key_content => $datacentred_encryption_key_public,
    key_type    => public,
    trust_level => '6',
  }

  gnupg_key { 'datacentred_private_encryption_key':
    ensure      => present,
    key_id      => $datacentred_encryption_key_short_id,
    user        => 'root',
    key_content => $datacentred_encryption_key_private,
    key_type    => private,
    trust_level => '6',
  }

}