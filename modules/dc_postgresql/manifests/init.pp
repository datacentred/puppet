# Class: dc_postgresql
#
# Top level class to install the db
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
class dc_postgresql (
  $ip_mask_users    = '0.0.0.0/0',
  $ip_mask_postgres = '0.0.0.0/32',
  $listen           = '*',
  $barmanpath       = hiera(barman_path),
  $pgbackupserver   = hiera(pg_backup_server),
){

  # Install the sever to listen on the chosen address range
  class { '::postgresql::server':
    ip_mask_allow_all_users      => $ip_mask_users,
    ip_mask_deny_postgres_user   => $ip_mask_postgres,
    listen_addresses             => $listen,
  }

  class { 'dc_postgresql::pg_backup':
    barmanpath     => $barmanpath,
    pgbackupserver => $pgbackupserver,
    require        => Class['::postgresql::server'],
  }

  class { 'dc_postgresql::icinga': }

# FIXME Add define for databases

}


