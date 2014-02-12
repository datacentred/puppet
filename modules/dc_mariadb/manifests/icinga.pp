# Class: dc_mariadb::icinga
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
class dc_mariadb::icinga {

  class { '::mysql::server::monitor':
    mysql_monitor_username => 'icinga',
    mysql_monitor_password => 'icinga',
    mysql_monitor_hostname => hiera(icinga_ip)
  }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_mysql']

}

