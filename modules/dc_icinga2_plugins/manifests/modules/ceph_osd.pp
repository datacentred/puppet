# == Class: dc_icinga2_plugins::modules::ceph_osd
#
# Plugins specific to ceph OSDs
#
class dc_icinga2_plugins::modules::ceph_osd {

  dc_icinga2_plugins::module { 'ceph_osd':
    plugins => [
      'check_ceph_memory',
      'check_ceph_osd',
    ],
  }

}
