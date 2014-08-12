# Class: dc_juniperbackups
#
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
class dc_juniperbackups {

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
    ensure      => present,
    options => 'noauto,_netdev',
    mount       => "${juniper_directory}-remote",
  }

  tidy { $juniper_directory:
    age    => '12w',
    backup => false,
  }

  file { '/usr/local/sbin/junipercopy.sh':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('dc_juniperbackup/junipercopy.sh.erb'),
  }

  cron { 'nfscopy':
    command => '/usr/local/sbin/junipercopy.sh',
    user    => root,
    hour    => 4,
    minute  => 0,
    require => Tidy[$juniper_directory],
  }

  @@file { "${::hostname}-juniperbackup":
    ensure  => directory,
    path    => "${storagedir}/backups/${::hostname}-juniperbackup",
    require => File["${storagedir}/backups"],
    tag     => 'backups',
  }

  @@nfs::server::export { "${storagedir}/backups/${::hostname}-juniperbackup":
    ensure  => present,
    require => File["${::hostname}-juniperbackup"],
    clients => "${::ipaddress}(rw,insecure,async,no_root_squash,no_subtree_check)",
    tag     => 'backups',
    nfstag  => "${::hostname}-juniperbackup",
  }

}
