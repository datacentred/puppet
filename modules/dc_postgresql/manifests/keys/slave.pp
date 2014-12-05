# == Class: dc_postgresql::keys::slave
#
# Key configuration for backups and clustering
#
class dc_postgresql::keys::slave {

  include ::dc_postgresql::params

  if $::postgres_key {

    file { "${dc_postgresql::params::pghome}/.ssh/config":
      ensure  => file,
      content => template('dc_postgresql/slave_ssh_config.erb'),
      owner   => 'postgres',
      group   => 'postgres',
      mode    => '0600',
    }

  }

}

