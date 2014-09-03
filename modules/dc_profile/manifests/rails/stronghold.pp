# Class: dc_profile::rails::stronghold
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
class dc_profile::rails::stronghold {

  dc_rails::app { 'stronghold':
    app_name        => 'stronghold',
    app_url         => 'stronghold.dev',
    app_repo        => 'git@github.com:datacentred/stronghold.git',
    ssl_key         => 'puppet:///modules/dc_ssl/stronghold/stronghold.dev.key',
    ssl_cert        => 'puppet:///modules/dc_ssl/stronghold/stronghold.dev.crt',
    secret_key_base => hiera(rails::server::stronghold::secret_key_base),
    rails_env       => 'staging',
  }

}
