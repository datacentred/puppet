class dc_profile::nfsserver {

  include nfs::server

  $storagedir = hiera(storagedir)

  file { "$storagedir":
    ensure => directory
  }

  File <<| tag == "backups" |>>

  file { "$storagedir/backups":
    ensure  => directory,
    require => File["$storagedir"],
  }

  file { "$storagedir/nfsroot":
    ensure  => directory,
    require => File["$storagedir"],
  }

  nfs::server::export { "$storagedir/nfsroot":
    ensure  => 'present',
    require => File["$storagedir/nfsroot"],
    clients => '10.10.0.0/16(ro,insecure,async,no_root_squash,no_subtree_check,no_all_squash)',
    nfstag  => 'nfsroot',
  }

  Nfs::Server::Export <<| tag == "backups" |>>

}
