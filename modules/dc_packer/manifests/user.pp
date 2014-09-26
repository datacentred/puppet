# == Class: dc_packer::user
#
class dc_packer::user {
  user { 'packer':
    ensure     => present,
    system     => true,
    home       => '/home/packer',
    managehome => true,
    comment    => 'Account for building VM images via Packer',
    shell      => '/bin/bash',
  }
}
