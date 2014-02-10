class dc_profile::gdash {
  class { 'dc_gdash':
    gdash_root => '/var/www/gdash'
  }

  Dc_gdash::Hostgraph <<| |>>
}
