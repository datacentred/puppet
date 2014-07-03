# Class: dc_ceph::osd
#
# Responsible for defining which devices get ceph installed
# on them and detecting which SSD is used as journal storage
# for each drive
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph::osd (
  $ceph_setup_pools,
  $ceph_deploy_user,
  $ceph_primary_mon,
  $ceph_cluster_interface,
  $ceph_cluster_network,
  $ceph_journal_disk,
  $ceph_journal_size,
  $ceph_num_osds,
  $ceph_osds,
){

  Exec {
    path => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin',
  }

  package { 'xfsprogs':
    ensure => installed,
  } ->

  file { '/usr/local/bin/journal-provision':
    source => 'puppet:///modules/dc_ceph/provision.py',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  exec { "/usr/local/bin/journal-provision ${ceph_journal_disk} ${ceph_num_osds} ${ceph_journal_size}": } ->

  cephdeploy::osd { $osds:
    setup_pools            => $ceph_setup_pools,
    ceph_deploy_user       => $ceph_deploy_user,
    ceph_primary_mon       => $ceph_primary_mon,
    ceph_cluster_interface => $ceph_cluster_interface,
    ceph_cluster_network   => $ceph_cluster_network,
    glance_ceph_pool       => undef,
    cinder_rbd_pool        => undef,
  }

}
