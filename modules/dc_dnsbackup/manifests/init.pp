# == Class: dc_dnsbackup
#
# Periodically back up requested zones to a specified directory
#
# === Parameters
#
# [*target*]
#   Target directory to store the zone backups to
#
class dc_dnsbackup (
  $target = '/var/zonebackups'
) {

  file { $target:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { 'dnsbackup.sh':
    ensure  => file,
    path    => '/usr/local/bin/dnsbackup.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('dc_dnsbackup/dnsbackup.sh.erb')
  }

  file { '/etc/dnsbackup.conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  cron { 'dnsbackup':
    ensure  => present,
    command => '/usr/local/bin/dnsbackup.sh /etc/dnsbackup.conf.d',
    user    => 'root',
    hour    => '2',
    minute  => '0',
  }

  tidy { '/var/zonebackups':
    age     => '1w',
    recurse => true,
    rmdirs  => true,
  }

}
