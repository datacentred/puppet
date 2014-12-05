# == Class: dc_postgresql::keys::cluster
#
# Key configuration for backups and clustering
#
class dc_postgresql::keys::cluster  {

  include ::dc_postgresql::params

  Ssh_authorized_key <<| tag == postgres_cluster |>>

  if $::postgres_key {

    $cluster_key_elements = split($::postgres_key, ' ')

    @@ssh_authorized_key { "postgres_cluster_key_${::hostname}" :
      ensure  => present,
      type    => 'ssh-rsa',
      key     => $cluster_key_elements[1],
      user    => 'postgres',
      tag     => postgres_cluster,
    }

  }

}

