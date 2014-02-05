# Class: dc_mariadb::exports
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
class dc_mariadb::exports {

  $storagedir = hiera(storagedir)

  @@file { "${::hostname}-mariadbbackup":
    ensure  => directory,
    path    => "${storagedir}/backups/${::hostname}-mariadbbackup",
    require => File["${storagedir}/backups"],
    tag     => 'backups',
  }

  @@nfs::server::export { "${storagedir}/backups/${::hostname}-mariadbbackup":
    ensure  => present,
    require => File["${::hostname}-mariadbbackup"],
    clients => "${::ipaddress}(rw,insecure,async,no_root_squash,no_subtree_check)",
    tag     => 'backups',
    nfstag  => "${::hostname}-mariadbbackup"
  }

}


