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

  class { 'dc_rails::server': } ->

  dc_rails::app { 'soleman':
    app_name => 'soleman',
    app_url  => 'support.datacentred.co.uk',
    app_repo => 'git@github.com:datacentred/soleman.git',
    ssl_key  => 'puppet:///modules/dc_ssl/soleman/soleman.dev.key',
    ssl_cert => 'puppet:///modules/dc_ssl/soleman/soleman.dev.crt',
  } ->

  dc_dns::cname { 'support.datacentred.co.uk':
    ensure   => 'present',
    ttl      => '86400',
    alias_to => 'rails01.sal01.datacentred.co.uk'
  }
}
