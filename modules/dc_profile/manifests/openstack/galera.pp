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

  # We only want to be our designated master to be actively written to,
  # unless it's failed of course.
  if $::fqdn == $galera_master {
    $haproxy_options = 'check port 9200 inter 30000 rise 2 fall 5'
  }
  else {
    $haproxy_options = 'check port 9200 inter 30000 rise 2 fall 5 backup'
  }

  # Export our haproxy balancermember resource
  @@haproxy::balancermember { "${::fqdn}-galera":
    listening_service => 'icehouse-galera',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '3306',
    options           => $haproxy_options,
  }

}
