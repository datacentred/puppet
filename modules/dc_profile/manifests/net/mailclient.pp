# Class: dc_profile::net::mailclient
#
# Installs postfix as a null client
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::mailclient {

  class { 'dc_postfix':
    nullclient    => true,
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_postfix']

}
