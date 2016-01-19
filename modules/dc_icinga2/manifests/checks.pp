# == Class: dc_icinga2::checks
#
class dc_icinga2::checks {

  Icinga2::Object::Checkcommand {
    target => '/etc/icinga2/zones.d/global-templates/checks.conf',
  }

  icinga2::object::checkcommand { 'memory':
    command   => [
      'PluginDir + "/check_memory"',
    ],
    arguments => {
      '-w' => '$memory_warn_bytes$',
      '-c' => '$memory_critical_bytes$',
      '-u' => '$memory_unit$',
      '-t' => '$memory_timeout$',
    },
  }

  icinga2::object::checkcommand { 'sensors':
    command => [
      'PluginDir + "/check_sensors"',
    ],
  }

  icinga2::object::checkcommand { 'bmc':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_bmc"',
    ],
    arguments => {
      '-H' => '$bmc_host$',
      '-u' => '$bmc_username$',
      '-p' => '$bmc_password$',
      '-r' => '$bmc_revision$',
    },
  }

  icinga2::object::checkcommand { 'psu':
    command   => [
      '"sudo"',
      '"/usr/local/lib/nagios/plugins/check_psu"',
    ],
    arguments => {
      '-a' => '$psu_a_raw$',
      '-b' => '$psu_b_raw$',
    },
  }

  icinga2::object::checkcommand { 'ceph-health':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_health"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_health_exe$',
      '-c' => '$ceph_health_conf$',
      '-m' => '$ceph_helath_monaddress$',
      '-i' => '$ceph_health_id$',
      '-k' => '$ceph_health_keyring$',
      '-d' => {
        'set_if' => '$ceph_health_detail$',
      },
    },
    vars      => {
      'ceph_health_detail' => false,
    }
  }

  icinga2::object::checkcommand { 'ceph-mon':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_mon"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_mon_exe$',
      '-c' => '$ceph_mon_conf$',
      '-m' => '$ceph_mon_monaddress$',
      '-i' => '$ceph_mon_id$',
      '-k' => '$ceph_mon_keyring$',
      '-I' => '$ceph_mon_monid$',
      '-H' => '$ceph_mon_monhost$',
    },
  }

  icinga2::object::checkcommand { 'ceph-osd':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_osd"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_osd_exe$',
      '-c' => '$ceph_osd_conf$',
      '-m' => '$ceph_osd_monaddress$',
      '-i' => '$ceph_osd_id$',
      '-k' => '$ceph_osd_keyring$',
      '-H' => '$ceph_osd_host$',
      '-I' => '$ceph_osd_osdid$',
      '-o' => '$ceph_osd_out$',
    },
  }

  icinga2::object::checkcommand { 'ceph-rgw':
    command   => [
      '"/usr/local/lib/nagios/plugins/check_ceph_rgw"',
    ],
    timeout   => 120,
    arguments => {
      '-e' => '$ceph_rgw_exe$',
      '-c' => '$ceph_rgw_conf$',
      '-i' => '$ceph_rgw_id$',
    },
  }

  icinga2::object::checkcommand { 'smart':
    command   => [
      '"sudo"',
      'PluginDir + "/check_scsi_smart"',
    ],
    arguments => {
      '-d' => '$smart_device$',
    },
  }

  icinga2::object::checkcommand { 'dhcp_sudo':
    command   => [
      '"sudo"',
      'PluginDir + "/check_dhcp"',
    ],
    arguments => {
      '-s' => '$dhcp_serverip$',
      '-r' => '$dhcp_requestedip$',
      '-t' => '$dhcp_timeout$',
      '-i' => '$dhcp_interface$',
      '-m' => '$dhcp_mac$',
      '-u' => {
        'set_if' => '$dhcp_unicast$',
      },
    },
    vars      => {
      'dhcp_unicast' => false,
    },
  }

}
