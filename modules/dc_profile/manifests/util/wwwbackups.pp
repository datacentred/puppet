# Class: dc_profile::util::wwwbackups
#
# Takes care of scheduling a nightly backup of the DataCentred website
#
# Parameters:
#
# Actions:
#
# Requires: Private key to be placed in the 'backup' user's home directory.
# Corresponding script in place on the webserver that does the necessary
# mysqldump and copying of the website into /srv/backup/
#
# Sample Usage:
#
class dc_profile::util::wwwbackups {

  $wwwbackup_home = '/var/storage/backups/www.datacentred.co.uk'

  package { 'rsync':
    ensure => installed;
  }

  # default backup account
  user { 'backup':
    ensure  => present,
    comment => 'backup',
    home    => '/var/backups',
    system  => true,
  }

  user { 'wwwbackup':
    ensure     => present,
    comment    => 'Account used for backups related to the DC website',
    home       => $wwwbackup_home,
    managehome => true,
    system     => true,
  }

  cron { 'rsync_backup':
    user    => 'wwwbackup',
    command => "/usr/bin/rsync -ae 'ssh -i ${wwwbackup_home}/.ssh/dcwebsite.pem' ubuntu@www.datacentred.co.uk:/srv/backup/* ~/",
    hour    => 4,
    minute  => 0,
    require => [ User['wwwbackup'], Package['rsync'] ],
  }

}
