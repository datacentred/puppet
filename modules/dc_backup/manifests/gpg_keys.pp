# == Class: dc_backup::gpg_keys
#
# Sets up gpg signing and encryption keys on nodes with backups
#
class dc_backup::gpg_keys (
  $public_signing_key = dc_backup::gpg_keys::datacentred_signing_key::public,
  $private_signing_key = dc_backup::gpg_keys::datacentred_signing_key::private,
  $signing_key_short_id = dc_backup::gpg_keys::datacentred_signing_key::short_id,
  $signing_key_long_id = dc_backup::gpg_keys::datacentred_signing_key::long_id,
  $public_encryption_key = dc_backup::gpg_keys::datacentred_encryption_key::public,
  $encryption_key_short_id = dc_backup::gpg_keys::datacentred_encryption_key::short_id,
  $encryption_key_long_id = dc_backup::gpg_keys::datacentred_encryption_key::long_id,
) inherits dc_backup::params {

  include 'gnugp'

  gnupg_key { 'datacentred_public_signing_key':
    ensure      => present,
    key_id      => $signing_key_short_id,
    user        => 'root',
    key_content => $public_signing_key,
    key_type    => public,
  }

  gnupg_key { 'datacentred_private_signing_key':
    ensure      => present,
    key_id      => $signing_key_short_id,
    user        => 'root',
    key_content => $private_signing_key,
    key_type    => private,
  }

  gnupg_key { 'datacentred_public_encryption_key':
    ensure      => present,
    key_id      => $encryption_key_short_id,
    user        => 'root',
    key_content => $public_encryption_key,
    key_type    => public,
  }

  exec { 'do_you_want_to_build_a_trustdb':
    command => 'cat $signing_key_long_id > /tmp/$signing_key_long_id.keyid; cat ":6:" > /tmp/$signing_key_long_id.keyid; cat $encryption_key_long_id > /tmp/$encryption_key_long_id.keyid; cat ":6:" > /tmp/$encryption_key_long_id.keyid; gpg --import-ownertrust /tmp/$signing_key_long_id.keyid; gpg --import-ownertrust /tmp/$encryption_key_long_id.keyid',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    user    => 'root',
  }

  exec { ''}

}