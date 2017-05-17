# == Class: dc_profile::openstack::heat_db
#
class dc_profile::openstack::heat {

  service { [ 'heat-api', 'heat-api-cfn', 'heat-engine' ]:
    ensure =>  stopped,
  }

}
