# == Class: dc_backup::gpg_keys
#
# Sets up gpg signing and encryption keys on nodes with backups
#
class dc_backup::gpg_keys (
  $datacentred_public_signing_key = dc_backup::gpg_keys::datacentred_public_signing_key,
  $datacentred_private_signing_key = dc_backup::gpg_keys::datacentred_private_signing_key,
  $datacentred_public_encryption_key = dc_backup::gpg_keys::datacentred_public_encryption_key,
) inherits dc_backup::params {

}