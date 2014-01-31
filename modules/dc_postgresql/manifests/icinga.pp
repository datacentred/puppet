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

  $icinga_ip = hiera(icinga_ip)

  # A test database for Nagios to probe
  postgresql::server::db { 'nagiostest':
    user     => 'nagios',
    password => 'nagios',
    require  => Class['::postgresql::server'],
  }

  # Create a fact defining the required ipv4acl entry
  dc_external_facts::fact::def { 'pg_acl_icinga_check':
    value => "host nagios nagios ${icinga_ip}/32 password",
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_postgres']

}

