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

  class { 'dc_icinga::server':
    require => Class['dc_profile::icinga_client'],
  }

}

