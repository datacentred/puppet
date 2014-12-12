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
    require       => File['/var/lib/mysql'],
  }

  # We only want to be our designated master to be actively written to,
  # unless it's failed of course. $::galera_master is set via Foreman
  if $::galera_master {
    $haproxy_options = 'check port 9200 inter 2000 rise 2 fall 5'
  }
  else {
    $haproxy_options = 'check port 9200 inter 2000 rise 2 fall 5 backup'
  }

  # $::backup_node is set via Foreman
  if $::backup_node {
    $backupuser     = hiera(osdbmq_galera_backup_user)
    $backuppassword = hiera(osdbmq_galera_backup_pw)
    mysql_user { "${backupuser}@localhost":
    ensure        => present,
    password_hash => mysql_password($backuppassword),
    provider      => 'mysql',
    require       => Class['mysql::server::root_password'],
    }
    mysql_grant { "${backupuser}@localhost/*.*":
      ensure     => present,
      user       => "${backupuser}@localhost",
      table      => '*.*',
      privileges => [ 'SELECT', 'RELOAD', 'LOCK TABLES', 'SHOW VIEW' ],
      require    => Mysql_user["${backupuser}@localhost"],
    }
    file { '/var/local/backup':
      ensure => directory,
      mode   => '0700',
    }
    include ::dc_backup::duplicity
  }

  # Export our haproxy balancermember resource
  @@haproxy::balancermember { "${::fqdn}-galera":
    listening_service => 'galera',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '3306',
    options           => $haproxy_options,
  }

}
