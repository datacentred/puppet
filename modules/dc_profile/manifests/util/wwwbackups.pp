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

  package { 'rsync':
    ensure => installed;
  }

  user { 'backup':
    ensure     => present,
    comment    => 'Account used to backup related actions',
    home       => '/var/storage/backups/www.datacentred.co.uk',
    managehome => true,
  }

  cron { 'rsync_backup':
    user    => 'backup',
    command => "/usr/bin/rsync -ae 'ssh -i ~/.ssh/dcwebsite.pem' ubuntu@www.datacentred.co.uk:/srv/backup/* ~/",
    hour    => 4,
    minute  => 0,
    require => [ User['backup'], Package['rsync'] ],
  }

}
