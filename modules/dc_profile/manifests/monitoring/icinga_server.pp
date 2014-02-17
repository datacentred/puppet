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
class dc_profile::monitoring::icinga_server {

  class { 'dc_icinga::server':
    # todo: what is this dependency for??
    require => Class['dc_profile::monitoring::icinga_client'],
  }
  contain 'dc_icinga::server'

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_http']

}

