# Class: dc_dnsbackup
#
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
class dc_dnsbackup(

  $dnsbackupmount = '/var/zonebackups'

){

  $nfs_backup_server = hiera(nfs_backup_server)

  file { 'backupmount':
    ensure => directory,
    path   => "${dnsbackupmount}",
  }

  file { 'dnsbackup.sh':
    ensure  => file,
    path    => '/usr/local/bin/dnsbackup.sh',
    owner   => root,
    group   => root,
    mode    => '0754',
    content => template('dc_dnsbackup/dnsbackup.sh.erb')
  }

  file { '/etc/dnsbackup.conf.d':
    ensure => directory,
    owner  => root,
    group  => root,
  }

  cron { 'dnsbackup':
    ensure  => present,
    command => '/usr/local/bin/dnsbackup.sh /etc/dnsbackup.conf.d',
    user    => root,
    hour    => '2',
    minute  => '0',
  }

  class { dc_dnsbackup::exports: }

  Dc_dnsbackup::Backupzone <<| |>>

}
