# Class: dc_postgresql::icinga
#
# Add monitoring configuration for icinga
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
class dc_postgresql::icinga {

  # A test database for Nagios to probe
  postgresql::server::db { 'nagiostest':
    user     => 'nagios',
    password => 'nagios',
    require  => Class['::postgresql::server'],
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_postgres']

}

