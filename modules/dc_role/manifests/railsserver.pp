# Class: dc_role::soleman
#
# Management console server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::soleman {
  contain dc_profile::rails::server

  class { 'dc_rails':
    app_name           => 'soleman',
    app_url            => 'soleman.dev',
    app_repo           => 'git@github.com:datacentred/soleman.git',
    ssl_key            => 'puppet:///modules/dc_ssl/soleman/soleman.dev.key',
    ssl_cert           => 'puppet:///modules/dc_ssl/soleman/soleman.dev.crt',
  }
}
