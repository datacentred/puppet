# Class:
#
# Icinga server instance
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::icinga_server {

  include dc_profile::icinga_client

  class { 'dc_icinga::server':
    require => Class['dc_profile::icinga_client'],
  }

}

