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

  # Dear Matt,
  # Unbreak me

  #postgresql::server::role { 'nagios':
  #  password_hash => postgresql_password('nagios', $dc_postgresql::params::icinga_password),
  #}

  #postgresql::server::database_grant { 'nagios':
  #  privilege => 'ALL',
  #  db        => 'nagiostest',
  #  role      => 'nagios',
  #  require   => Postgresql::Server::Database['nagiostest'],
  #}

  #postgresql::server::database { 'nagiostest':
  #  dbname  => 'nagiostest',
  #  owner   => 'nagios',
  #  require => Postgresql::Server::Role['nagios'],
  #}

  include dc_icinga::hostgroup_postgres

}

