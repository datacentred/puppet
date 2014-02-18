# Class: dc_profile::perf::gdash
#
# Installs the whizzy graphite dashboard
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::perf::gdash {

  class { 'dc_gdash':
    gdash_root      => '/var/www/gdash',
    graphite_server => hiera(graphite_server),
  }

  Dc_gdash::Hostgraph <<| |>>
  Dc_gdash::Nettraf <<| |>>

}
