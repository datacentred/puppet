class dc_nrpe::ceph {

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/usr/lib/nagios/plugins/check_ceph_health':
    source => 'puppet:///modules/dc_nrpe/check_ceph_health',
  }

  file { '/usr/lib/nagios/plugins/check_ceph_mon':
    source => 'puppet:///modules/dc_nrpe/check_ceph_mon',
  }

  file { '/usr/lib/nagios/plugins/check_ceph_osd':
    source => 'puppet:///modules/dc_nrpe/check_ceph_osd',
  }

  file { '/usr/lib/nagios/plugins/check_ceph_rgw':
    source => 'puppet:///modules/dc_nrpe/check_ceph_rgw',
  }

}