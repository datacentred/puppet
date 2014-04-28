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

  $storagedir = hiera('storagedir')
  $password   = hiera('juniper_backups_password')

  user { 'juniperbackup':
    comment    => 'Juniper Backups Storage User',
    password   => generate('/bin/sh', '-c', "mkpasswd -m sha-512 ${password} | tr -d '\n'"),
    managehome => true,
    system     => true,
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
  }

}
