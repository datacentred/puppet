# Class: dc_rails::webserver
#
# Setup the webserver for a Rails server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_rails::webserver(
  $proxy = undef,
  $app_name = undef,
  $app_url = undef,
  $ssl_cert = undef,
  $ssl_key = undef,
) {
  class { 'nginx': manage_repo => false }

  nginx::resource::upstream { $app_name:
    ensure  => present,
    members => [
      $proxy,
    ],
  } ->

  nginx::resource::vhost { $app_url:
    ensure   => present,
    proxy    => "http://${app_name}",
    ssl      => true,
    ssl_cert => $ssl_cert,
    ssl_key  => $ssl_key,
  }
}