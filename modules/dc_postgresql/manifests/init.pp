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
  $ip_mask_postgres = '0.0.0.0/0',
  $listen           = '*',
  $barmanpath       = hiera(barman_path),
  $pgbackupserver   = hiera(pg_backup_server),
  $postgres_pw      = undef,
){

  # Install the sever to listen on the chosen address range
  class { '::postgresql::server':
    ip_mask_allow_all_users    => $ip_mask_users,
    ip_mask_deny_postgres_user => $ip_mask_postgres,
    listen_addresses           => $listen,
    postgres_password          => $postgres_pw
  }
  contain 'postgresql::server'

  class { 'dc_postgresql::pg_backupconfig':
    barmanpath     => $barmanpath,
    pgbackupserver => $pgbackupserver,
  }

  class { 'dc_postgresql::backupkeys': }
  contain 'postgresql::server'

  class { 'dc_postgresql::icinga': }

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact::Def['dc_hostgroup_postgres']

}
