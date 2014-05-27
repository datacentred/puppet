# Class: dc_ceph::exports
#
# NFS exports for ceph key backups
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::exports {

  if $::hostname == hiera(cephdeploy_primary_mon) {

    $storagedir = hiera(storagedir)

    @@file { 'ceph-keybackup':
      ensure  => directory,
      path    => "${storagedir}/backups/ceph-keybackup",
      require => File["${storagedir}/backups"],
      tag     => 'backups',
    }

    @@nfs::server::export { "${storagedir}/backups/ceph-keybackup":
      ensure  => present,
      require => File['ceph-keybackup'],
      clients => "${::ipaddress}(rw,insecure,async,no_root_squash,no_subtree_check",
      tag     => 'backups',
      nfstag  => 'ceph-keybackup',
    }

  }

}
