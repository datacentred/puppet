# Class: dc_postgresql::standby_sync
#
# Initial standby sync config
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
class dc_postgresql::standby_sync {

  include ::dc_postgresql::params

  $hosts = query_nodes("Ssh_authorized_key[postgres_cluster_key_${::hostname}]")

  if member($hosts, "$dc_postgresql::params::cluster_master_node.${::domain}") {

    notify { 'Authorized keys found on master, checking if initial sync process has run': }

    runonce { 'stop_pg_presync':
      command => '/usr/sbin/service postgresql stop',
    }->
    runonce { 'delete_all':
      command => "rm -rf ${dc_postgresql::params::pgdata}/*",
    }->
    runonce { 'repmgr_initial_sync':
      command => "su postgres -c \"repmgr -D ${dc_postgresql::params::pgdata} -d repmgr -p 5432 -U repmgr -R postgres --verbose standby clone ${dc_postgresql::params::cluster_master_node}\"",
    }->
    runonce { 'restart_postgres':
      command => '/usr/sbin/service postgresql start'
    }->
    service { 'repmgrd':
      ensure     => running,
      provider   => base,
      start      => "/usr/bin/repmgrd -f ${dc_postgresql::params::pgdata}/../../repmgr/repmgr.conf --verbose --monitoring-history > ${dc_postgresql::params::pgdata}/../../repmgr/repmgr.log 2>&1 &",
      stop       => 'killall repmgrd',
      hasrestart => false,
      hasstatus  => false,
    }

  }

  else {
    warning('Authorized key not found on master')
  }

}

