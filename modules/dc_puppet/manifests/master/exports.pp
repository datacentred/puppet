# Class: dc_puppet::master::exports
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
class dc_puppet::master::exports {

  $storagedir = hiera(storagedir)

  @@file { "${::hostname}-puppetcertsbackup":
    ensure  => directory,
    path    => "${storagedir}/backups/${::hostname}-puppetcertsbackup",
    require => File["${storagedir}/backups"],
    tag     => 'backups',
  }

  @@nfs::server::export { "${storagedir}/backups/${::hostname}-puppetcertsbackup":
    ensure  => present,
    require => File["${::hostname}-puppetcertsbackup"],
    clients => "${::ipaddress}(rw,insecure,async,no_root_squash,no_subtree_check)",
    tag     => 'backups',
    nfstag  => "${::hostname}-puppetcertsbackup",
  }

}


