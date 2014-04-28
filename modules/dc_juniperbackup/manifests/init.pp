# Class: dc_juniperbackup
#
# Juniper switch backups
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_juniperbackup {

  $password = hiera('juniper_backups_password')

  user { 'juniperbackup':
    comment    => 'Juniper Backups Storage User',
    password   => generate('/bin/sh', '-c', "mkpasswd -m sha-512 ${password} | tr -d '\n'"),
    home       => '/var/juniperbackup', 
    managehome => true,
    system     => true,
  }

  Nfs::Client::Mount <<| nfstag == "${::hostname}-juniperbackup" |>> {
    ensure  => mounted,
    mount   => '/var/juniperbackup-remote',
  }

  contain dc_juniperbackup::exports

}
