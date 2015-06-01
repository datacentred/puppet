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

  # Logrotation recommendations as per https://jira.mongodb.org/browse/SERVER-11087
  logrotate::rule { 'mongodb_logs':
    path          => '/var/log/mongodb/mongodb.log',
    rotate        => '14',
    rotate_every  => 'day',
    ifempty       => false,
    create        => true,
    create_mode   => '640',
    create_owner  => 'mongod',
    create_group  => 'mongod',
    compress      => true,
    missingok     => true,
    delaycompress => true,
    sharedscripts => true,
    postrotate    => [ '/bin/kill -SIGUSR1 `cat /var/run/mongodb/mongod.pid 2>/dev/null` >/dev/null 2>&1',
                      'find /var/log/mongodb -type f -size 0 -regextype posix-awk -regex "^\/var\/log\/mongodb\/mongod\.log\.[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}$" -execdir rm {} \; >/dev/null 2>&1' ],
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
      include ::dc_icinga::hostgroup_mongodb
      include ::dc_logstash::client::mongodb
    }
  }

}


