#
class dc_profile::gdash {

  class { 'dc_gdash':
    gdash_root      => '/var/www/gdash',
    graphite_server => hiera(graphite_server),
  }

  Dc_gdash::Hostgraph <<| |>>
  Dc_gdash::Nettraf <<| |>>

}
