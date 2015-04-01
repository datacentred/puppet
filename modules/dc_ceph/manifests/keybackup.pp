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
class dc_ceph::keybackup (
  $primary_mon,
) {

  if $::hostname == $primary_mon {

    $sos_address      = hiera(internal_sysmail_address)
    $mountpoint       = '/var/ceph-keybackup'

    include ::nfs::client

    Nfs::Client::Mount <<| nfstag == 'ceph-keybackup' |>> {
      ensure  => present,
      options => 'noauto,_netdev',
      mount   => $mountpoint,
    }

    file { '/usr/local/bin/ceph-keybackup':
      ensure  => file,
      mode    => '0744',
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
