# Class: dc_profile::openstack::galera
#
# Configure Galera multi-master
#
# Parameters:
#
# Actions:
#
# Requires: galera, xinetd
#
# Sample Usage:
#
#
class dc_profile::openstack::galera {

  $galera_servers = hiera(osdbmq_members)
  $galera_master = $galera_servers[0]
  $root_password = hiera(osdbmq_galera_pw)

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
    galera_master      => $galera_master,
    galera_servers     => $galera_servers,
    vendor_type        => 'mariadb',
    root_password      => $root_password,
    configure_firewall => false,
    configure_repo     => true,
    local_ip           => $::ipaddress_bond0,
    bind_address       => '*',
    require            => File['/var/lib/mysql'],
    override_options   => {
              'mysqld'   => {
                'datadir' => '/srv/mysql',
              }
    },
  }

}
