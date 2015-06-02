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

  # Deploy our keyfile before we attempt to configure
  # the replicaset
  file { '/etc/mongodb.keyfile':
    content => hiera(ceilometer_mongodb_keyfile),
    mode    => '0600',
    owner   => 'mongodb',
    group   => 'mongodb',
    require => Package['mongodb-org-server'],
  } ->
  Mongodb_replset['ceilometer']

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

  # $::backup_node is set via the ENC (Foreman)
  if $::backup_node {
    file { '/srv/backup':
      ensure => directory,
      mode   => '0700',
    }
    include ::dc_profile::openstack::duplicity_mongodb
    include ::dc_backup::gpg_keys
  }

  unless $::is_vagrant {
    if $::environment == 'production' {
      include ::dc_logstash::client::mongodb
    }
  }

}


