# == Class: dc_postgresql::keys::backup
#
# Key configuration for backups and clustering
#
class dc_postgresql::keys::backup {

  include ::dc_postgresql::params

  # We're either the master or not a cluster member so apply the backup config unless we're on vagrant
  if $::virtual != 'virtualbox' {

    Ssh_authorized_key <<| tag == 'barman' |>>

    file { "${dc_postgresql::params::pghome}/.ssh/config":
        ensure  => file,
        content => template('dc_postgresql/backup_ssh_config.erb'),
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0600',
    }

    if $::postgres_key {

      $backup_key_elements = split($::postgres_key, ' ')

      @@ssh_authorized_key { "postgres_backup_key_${::hostname}" :
        ensure  => present,
        type    => 'ssh-rsa',
        key     => $backup_key_elements[1],
        user    => 'barman',
        options => "from=\"${::ipaddress}\"",
        tag     => postgres_backup_key,
      }

    }

  }

}

