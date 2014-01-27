# Class: dc_dnsbackup::exports
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
# [Remember: No empty lines between comments and class definition]
class dc_dnsbackup::exports{

  $storagedir = hiera(storagedir)

  @@file { "${::hostname}-dnsbackup":
    ensure  => directory,
    path    => "${storagedir}/backups/${::hostname}-dnsbackup",
    require => File["${storagedir}/backups"],
    tag     => 'backups',
  }

  @@nfs::server::export { "${storagedir}/backups/${::hostname}-dnsbackup":
    ensure  => present,
    require => File["${::hostname}-dnsbackup"],
    clients => "${::ipaddress}(rw,insecure,async,no_root_squash,no_subtree_check)",
    tag     => 'backups',
  }
}
