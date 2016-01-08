# == Class: dc_nrpe::checks::ceph
#
class dc_nrpe::checks::ceph (
  $public_ip = $::ipaddress_p1p1,
) {

  dc_nrpe::check { 'check_ceph_health':
    path   => '/usr/local/bin/check_ceph_health',
    source => 'puppet:///modules/dc_nrpe/check_ceph_health',
    sudo   => true,
  }

  dc_nrpe::check { 'check_ceph_mon':
    path   => '/usr/local/bin/check_ceph_mon',
    source => 'puppet:///modules/dc_nrpe/check_ceph_mon',
    args   => "-H ${public_ip} -I ${::hostname}",
    sudo   => true,
  }

  dc_nrpe::check { 'check_ceph_osd':
    path   => '/usr/local/bin/check_ceph_osd',
    source => 'puppet:///modules/dc_nrpe/check_ceph_osd',
    args   => "-H ${public_ip}",
    sudo   => true,
  }

  dc_nrpe::check { 'check_ceph_rgw':
    path   => '/usr/local/bin/check_ceph_rgw',
    source => 'puppet:///modules/dc_nrpe/check_ceph_rgw',
    args   => "-i radosgw.${::hostname}",
  }

}
