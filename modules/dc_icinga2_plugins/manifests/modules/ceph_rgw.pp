# == Class: dc_icinga2_plugins::modules::ceph_rgw
#
# Plugins specific to ceph rados gateways
#
class dc_icinga2_plugins::modules::ceph_rgw {

  dc_icinga2_plugins::module { 'ceph_rgw':
    plugins => [
      'check_ceph_rgw',
    ],
  }

}
