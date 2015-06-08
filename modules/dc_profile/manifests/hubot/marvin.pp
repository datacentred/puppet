# Class: dc_profile::hubot::marvin
#
# Provisions a node as a Hubot bot
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::hubot::marvin {

  include ::redis

  apt::key { 'nodesourcekey':
    source => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
  }

  apt::source{'nodesource_0.12':
    location => 'https://deb.nodesource.com/node_0.12',
    release  => $::lsbdistcodename,
    repos    => 'main',
  }

  package {'npm':} ->

  file { '/usr/local/bin/node':
    ensure => 'link',
    target => '/usr/bin/nodejs',
  } ->

  class { 'hubot': 
    nodejs_manage_repo => false
  }

}
