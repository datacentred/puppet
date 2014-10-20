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
  include apache
  include apache::mod::passenger
  include apache::mod::headers

  class { 'dc_gdash':
    gdash_root      => '/var/www/gdash',
    graphite_server => hiera(graphite_server),
  }

  dc_apache::vhost { 'gdash':
    servername => "gdash.${::domain}",
    docroot    => '/var/www/gdash/public',
    port       => 80,
    cname      => false,
  }
}
