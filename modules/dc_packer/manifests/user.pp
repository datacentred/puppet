class dc_packer::user {
  user { 'packer':
    ensure     => present,
    home       => "/home/packer",
    managehome => true,
    comment    => "Account for building VM images via Packer",
  }
}
