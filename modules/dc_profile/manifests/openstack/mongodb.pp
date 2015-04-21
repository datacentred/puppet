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

  # $::backup_node is set via the ENC (Foreman)
  if $::backup_node {
    file { '/srv/backup':
      ensure => directory,
      mode   => '0700',
    }
    include ::dc_backup::duplicity
    include ::dc_backup::gpg_keys
  }

  unless $::is_vagrant {
    if $::environment == 'production' {
      include ::dc_icinga::hostgroup_mongodb
      include ::dc_logstash::client::mongodb
    }
  }

}


