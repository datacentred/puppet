#
class dc_profile::db::galera {

  $galera_servers = hiera(galera_cluster_nodes)
  $galera_master = $galera_servers[0]
  $root_password = hiera(galera_cluster_root_pw)

  file { '/srv/mysql':
    ensure  => directory,
    recurse => true,
  }

  file { '/var/lib/mysql':
    ensure  => link,
    target  => '/srv/mysql',
    require => File['/srv/mysql'],
  }

  class { '::galera':
    galera_master         => $galera_master,
    galera_servers        => $galera_servers,
    vendor_type           => 'mariadb',
    root_password         => $root_password,
    configure_firewall    => false,
    configure_repo        => true,
    local_ip              => $::ipaddress_eth1,
    bind_address          => $::ipaddress_eth1,
    require               => File['/var/lib/mysql'],
    override_options      => {
            'mysqld'      => {
                'datadir' => '/srv/mysql',
          }
    },
  }

}
