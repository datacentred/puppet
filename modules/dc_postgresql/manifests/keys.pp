# Class: dc_postgresql::keys
#
# Key configuration for backups and clustering
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
class dc_postgresql::keys {

  include ::dc_postgresql::params

  if member($dc_postgresql::params::cluster_standby_nodes, $::fqdn) or $dc_postgresql::params::cluster_master_node == $::fqdn {

    Ssh_authorized_key <<| tag == postgres_cluster |>>

    if $::postgres_key {

      $cluster_key_elements = split($::postgres_key, ' ')

      @@ssh_authorized_key { "postgres_cluster_key_${::hostname}" :
        ensure  => present,
        type    => 'ssh-rsa',
        key     => $cluster_key_elements[1],
        user    => 'postgres',
        #options => "from=\"${::ipaddress}\"",
        tag     => postgres_cluster,
      }

    }
  }

  if member($dc_postgresql::params::cluster_standby_nodes, $::fqdn) {

    if $::postgres_key {

      file { "${dc_postgresql::params::pgdata}/../../.ssh/config":
        ensure  => file,
        content => template('dc_postgresql/slave_ssh_config.erb'),
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0600',
        require => Package['postgresql-server'],
      }
    }

  }

  # We're either the master or not a cluster member so apply the backup config unless we're on vagrant
  if $::virtual != 'virtualbox' and ( ( $dc_postgresql::params::cluster_master_node == $fqdn ) or ( ! member($dc_postgresql::params::cluster_standby_nodes, $::fqdn) ) ){

    Ssh_authorized_key <<| tag == 'barman' |>>

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

