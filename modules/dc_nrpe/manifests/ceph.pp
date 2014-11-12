# == Class: dc_nrpe::ceph
#
class dc_nrpe::ceph {

  Sudo::Conf {
    priority => 10,
  }

  sudo::conf { 'check_ceph_health':
    content => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_ceph_health',
  }

  sudo::conf { 'check_ceph_mon':
    content => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_ceph_mon',
  }

  sudo::conf { 'check_ceph_osd':
    content => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_ceph_osd',
  }

  sudo::conf { 'check_ceph_rgw':
    content => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_ceph_rgw',
  }

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
