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

  anchor { 'dc_profile::icinga_server::start': } ->
  class { 'dc_icinga::server':
    # todo: what is this dependency for??
    require => Class['dc_profile::icinga_client'],
  } ->
  anchor { 'dc_profile::icinga_server::end': }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_http']

}

