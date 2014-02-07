# Class: dc_puppetmaster::backup
#
# Config to backup the certs directory
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   class { 'dc_puppetmaster::backup':
#   }
#
#
class dc_puppetmaster::backup {

  include nfs::client

  # the NFS client class will create the mount point so we don't need to
  Nfs::Client::Mount <<| nfstag == "${::hostname}-puppetcertsbackup" |>> {
    ensure  => mounted,
    mount   => '/var/certsbackup',
  }

  file { '/usr/local/sbin/backupcerts':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => 'puppet:///modules/dc_puppetmaster/backupcerts',
  }

  cron { 'backupcerts':
    command => '/usr/local/sbin/backupcerts',
    user    => 'root',
    hour    => '2',
    minute  => '0',
  }

}
