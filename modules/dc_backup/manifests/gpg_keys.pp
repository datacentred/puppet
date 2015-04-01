# == Class: dc_backup::gpg_keys
#
# Sets up gpg signing and encryption keys on nodes with backups
#
class dc_backup::gpg_keys (
  $datacentred_public_signing_key = dc_backup::gpg_keys::datacentred_public_signing_key,
  $datacentred_private_signing_key = dc_backup::gpg_keys::datacentred_private_signing_key,
  $datacentred_public_encryption_key = dc_backup::gpg_keys::datacentred_public_encryption_key,
) inherits dc_backup::params {

  include 'gnugp'

  gnupg_key { 'datacentred_public_signing_key':
    ensure      => present,
    key_id      => 'DE654FAE',
    user        => 'root',
    key_content => $datacentred_public_signing_key,
    key_type    => public,
  }

  gnupg_key { 'datacentred_private_signing_key':
    ensure      => present,
    key_id      => 'DE654FAE',
    user        => 'root',
    key_content => $datacentred_private_signing_key,
    key_type    => private,
  }

  gnupg_key { 'datacentred_public_encryption_key':
    ensure      => present,
    key_id      => '942730D0',
    user        => 'root',
    key_content => $datacentred_public_encryption_key,
    key_type    => public,
  }

}