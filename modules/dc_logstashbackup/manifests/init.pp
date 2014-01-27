# Class: dc_logstashbackup
#
# Logstash ElasticSearch NFS backups
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
class dc_logstashbackup (
  $logstashlocalretention = '14',
  $logstashbackupmount    = '/var/lsbackups',
  $indicespath            = '/var/lib/logstash/data/elasticsearch/nodes/0/indices',
){

  package { 'curl':
    ensure => installed,
  }

  package { 'nfs-common':
    ensure => installed,
  }

  file { 'logstashbackup':
    ensure => file,
    path   => '/usr/local/bin/elasticsearch-backup-index.sh',
    owner  => root,
    group  => root,
    mode   => '0754',
    source => 'puppet:///modules/dc_logstashbackup/elasticsearch-backup-index.sh'
  }

  file { 'logstashtrim':
    ensure => file,
    path   => '/usr/local/bin/elasticsearch-remove-old-indices.sh',
    owner  => root,
    group  => root,
    mode   => '0754',
    source => 'puppet:///modules/dc_logstashbackup/elasticsearch-remove-old-indices.sh'
  }

  file { 'logstashbackupmount':
    ensure => directory,
    path   => "${logstashbackupmount}",
  }

  cron { 'logstashbackup':
    ensure  => present,
    command => "/usr/local/bin/elasticsearch-backup-index.sh -b ${logstashbackupmount} -i ${indicespath}",
    user    => root,
    hour    => '2',
    minute  => '0',
  }

  cron { 'logstashtrim':
    ensure  => present,
    command => "/usr/local/bin/elasticsearch-remove-old-indices.sh -i ${logstashlocalretention}",
    user    => root,
    hour    => '3',
    minute  => '0',
  }

  class { 'dc_logstashbackup::exports': }

}
