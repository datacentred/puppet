class dc_profile::nfsserver {

  include nfs::server

  $storagedir = hiera(storagedir)

  file { "$storagedir":
    ensure => directory
  }

  file { "$storagedir/backups":
    ensure  => directory,
    require => File["$storagedir"],
  }

  file { "$storagedir/nfsroot":
    ensure => directory,
    require => File["$storagedir"],
  }

  nfs::server::export { "$storagedir/backups":
    ensure  => 'present',
    require => File["$storagedir/backups"],
    clients => '10.10.192.0/24(rw,insecure,async,no_root_squash)',
    nfstag  => 'backups',
  }

  nfs::server::export { "$storagedir/nfsroot":
    ensure  => 'present',
    require => File["$storagedir/nfsroot"],
    clients => '10.10.0.0/16(rw,insecure,async,no_root_squash)',
    nfstag  => 'nfsroot',
  }

}
