class dc_profile::nfsserver {

  include nfs::server

  file { '/var/storage':
    ensure => directory
  }

  file { '/var/storage/backups':
    ensure  => directory,
    require => File['/var/storage'],
  }

  file { '/var/storage/nfsroot':
    ensure => directory,
    require => File['/var/storage'],
  }

  nfs::server::export { '/var/storage/backups':
    ensure  => 'present',
    require => File['/var/storage/backups'],
    clients => '10.10.192.0/24(rw,insecure,async,no_root_squash)',
    nfstag  => 'backups',
  }
  
  nfs::server::export { '/var/storage/nfsroot':
    ensure  => 'present',
    require => File['/var/storage/nfsroot'],
    clients => '10.10.0.0/16(rw,insecure,async,no_root_squash)',
    nfstag  => 'nfsroot',
  }

}
