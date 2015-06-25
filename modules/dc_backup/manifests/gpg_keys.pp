# == Class: dc_backup::gpg_keys
#
# Sets up gpg signing and encryption keys on nodes with backups
#
class dc_backup::gpg_keys {

  include ::gnupg

  Gnupg_key {
    ensure      => present,
    user        => 'root',
    trust_level => '6',
  }

  gnupg_key { 'datacentred_public_signing_key':
    key_type    => 'public',
    key_id      => $dc_backup::datacentred_signing_key_short_id,
    key_content => $dc_backup::datacentred_signing_key_public,
  }

  gnupg_key { 'datacentred_private_signing_key':
    key_type    => 'private',
    key_id      => $dc_backup::datacentred_signing_key_short_id,
    key_content => $dc_backup::datacentred_signing_key_private,
  }

  gnupg_key { 'datacentred_public_encryption_key':
    key_type    => 'public',
    key_id      => $dc_backup::datacentred_encryption_key_short_id,
    key_content => $dc_backup::datacentred_encryption_key_public,
  }

  gnupg_key { 'datacentred_private_encryption_key':
    key_type    => 'private',
    key_id      => $dc_backup::datacentred_encryption_key_short_id,
    key_content => $dc_backup::datacentred_encryption_key_private,
  }

}
