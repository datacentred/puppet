# == Class: dc_icinga2_plugins::modules::ceph_mon
#
# Plugins specific to ceph monitors
#
class dc_icinga2_plugins::modules::ceph_mon {

  dc_icinga2_plugins::module { 'ceph_mon':
    plugins => [
      'check_ceph_health',
      'check_ceph_mon',
    ],
  }

}
