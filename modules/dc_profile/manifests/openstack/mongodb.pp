# Class: dc_profile::openstack::mongodb
#
# MongoDB installation supporting OpenStack Ceilometer
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::mongodb {

  include ::mongodb::globals
  include ::mongodb::server
  include ::mongodb::client
  include ::mongodb::replset
  include ::dc_icinga::hostgroup_mongodb

  Class['::mongodb::server'] ->
  Class['::mongodb::client']

  # MongoDB rotates its logs on receipt of SIGUSR1
  cron { 'mongodb_logrotate':
    user    => root,
    command => '/bin/kill -SIGUSR1 `/bin/pidof mongod`',
    minute  => 0,
    hour    => 5,
  }

  tidy { 'mongodb_logclean':
    path    => '/var/log/mongodb',
    age     => '14d',
    matches => '*.log.*',
    recurse => true,
  }

}

