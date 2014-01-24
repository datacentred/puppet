# Class: dc_logstashbackup::exports
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

class dc_logstashbackup::exports {

  $storagedir = hiera(storage_dir)

  @@file { "$::hostname-logstashbackup":
    path    => "$storagedir/backups/$::hostname-logstashbackup",
    ensure  => directory,
    require => File["$storagedir/backups"],
    tag     => 'backups',
  }

  @@nfs::server::export { "$::hostname-logstashbackup":
    ensure  => present,
    require => File["$::hostname-logstashbackup"],
    clients => "$::hostname(rw,insecure,async,no_root_squash)",
    tag     => 'backups',
  }

}


