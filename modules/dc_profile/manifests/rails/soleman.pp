# Class: dc_profile::rails::server
#
# Provisions a node as a Rails server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::rails::soleman {

  contain 'dc_rails'

  class { 'dc_rails':
    app_name           => 'soleman',
    app_url            => 'soleman.dev',
    app_repo           => 'git@github.com:datacentred/soleman.git',
    ssl_key            => 'puppet:///modules/dc_ssl/soleman/soleman.dev.key',
    ssl_cert           => 'puppet:///modules/dc_ssl/soleman/soleman.dev.crt',
  }

}
