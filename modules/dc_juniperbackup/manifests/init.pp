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

  user { 'juniperbackup':
    comment    => 'Juniper Backups Storage User',
    shell      => '/sbin/nologin',
    password   => sha1(hiera('juniper_backups_password')),
    managehome => true,
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
