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

  apt::source{'nodesource_0.12':
    location => 'https://deb.nodesource.com/node_0.12',
    release  => $::lsbdistrelease,
    repos => 'main',
    key => {
      source => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
    }
  }

  class { 'hubot': 
    nodejs_manage_repo => false
  }

}
