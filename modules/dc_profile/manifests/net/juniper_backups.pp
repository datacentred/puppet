# Class: dc_profile::net::juniper_backups
#
# Creates an apt mirror
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::juniper_backups {

  $juniper_username      = hiera('juniper_backups_username')
  $juniper_password      = hiera('juniper_backups_password')
  $juniper_password_salt = hiera('juniper_backups_password_salt')
  $juniper_directory     = hiera('juniper_backups_directory')
  $storagedir            = hiera('storagedir')

  user { $juniper_username:
    comment    => 'Juniper Backups Storage User',
    password   => generate('/bin/sh', '-c', "mkpasswd -m sha-512 ${juniper_password} ${juniper_password_salt} | tr -d '\n'"),
    home       => $juniper_directory,
    managehome => true,
    system     => true,
  }

  Nfs::Client::Mount <<| nfstag == "${::hostname}-juniperbackup" |>> {
    ensure  => mounted,
    mount   => "${juniper_directory}-remote",
  }

  tidy { $juniper_directory:
    age    => '12w',
    backup => false,
  }

  cron { "juniperbackup-to-nfs":
    command => "rsync -r --delete ${juniper_directory} ${juniper_directory}-remote",
    hour    => 0,
    minute  => 0,
    require => Tidy[$juniper_directory],
  }

  @@file { "$::hostname-juniperbackup":
    ensure  => directory,
    path    => "${storagedir}/backups/$::hostname-juniperbackup",
    require => File["${storagedir}/backups"],
    tag     => 'backups',
  }

  @@nfs::server::export { "${storagedir}/backups/$::hostname-juniperbackup":
    ensure  => present,
    require => File["$::hostname-juniperbackup"],
    clients => "$::ipaddress(rw,insecure,async,no_root_squash,no_subtree_check)",
    tag     => 'backups',
    nfstag  => "${::hostname}-juniperbackup",
  }

}
