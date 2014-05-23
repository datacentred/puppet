# Class: dc_ceph::keybackup
#
# Saves the keys on the primary monitor node
# as this is needed to seed other nodes with
# cephdeploy
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::keybackup {

  if $::hostname == hiera(cephdeploy_primary_mon) {

    $sos_address      = hiera(sal01_internal_sysmail_address)
    $ceph_deploy_user = hiera(ceph_deploy_user)
    $mountpoint       = '/var/ceph-keybackup'

    include ::nfs::client

    Nfs::Client::Mount <<| nfstag == 'ceph-keybackup' |>> {
      ensure => mounted,
      mount  => $mountpoint,
    }

    file { '/usr/local/bin/ceph-keybackup':
      ensure  => file,
      mode    => 744,
      content => template('dc_ceph/ceph-keybackup.erb'),
    }

    cron { 'ceph-keybackup':
      command => '/usr/local/bin/ceph-keybackup',
      user    => 'root',
      hour    => 4,
      minute  => 0,
    }

  }

}
