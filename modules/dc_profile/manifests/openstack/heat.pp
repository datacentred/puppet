# == Class: dc_profile::openstack::heat
#
class dc_profile::openstack::heat {

  $containers = hiera('containers')

  dc_docker::run { 'heat':
    * => $containers['heat']
  }

  service { [ 'heat-api', 'heat-api-cfn', 'heat-engine' ]:
    ensure =>  stopped,
  }

}
