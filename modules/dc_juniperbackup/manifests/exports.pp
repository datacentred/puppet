# Class: dc_juniperbackup::exports
#
# Exports the file and nfs export classes for the server to pick up
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
class dc_juniperbackup::exports {

  $storagedir = hiera('storagedir')

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
