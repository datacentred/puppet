# Class: dc_mariadb::backupconf
#
# Server side configuration for backups
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
class dc_mariadb::backupconf (
){

  include nfs::client

  Nfs::Client::Mount <<| nfstag == "${::hostname}-mariadbbackup" |>> {
    ensure  => mounted,
    mount   => '/var/dbbackups-remote',
  }

  class { 'mysql::server::backup':
    backupuser        => 'backup',
    backuppassword    => hiera(backup_mysql_pw),
    backupdir         => '/var/dbbackups',
    backuprotate      => '7',
    file_per_database => true,
    time              => ['3','00']
  }
  contain 'mysql::server'

  file { '/usr/local/sbin/nfscopy.sh':
    ensure => file,
    mode   => '0744',
    source => 'puppet:///modules/dc_mariadb/nfscopy.sh',
  }

}

