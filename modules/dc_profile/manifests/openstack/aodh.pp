# Class: dc_profile::openstack::aodh
#
# Telemetry: OpenStack Alarming service
#
class dc_profile::openstack::aodh {

  $containers = hiera('containers')

  dc_docker::run { 'aodh':
    * => $containers['aodh']
  }

  dc_docker::logrotate { 'aodh': }

}
