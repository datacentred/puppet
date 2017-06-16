# Class: dc_profile::openstack::ceilometer::control
#
# Main Ceilometer components for deployment on a cloud control node
#
class dc_profile::openstack::ceilometer::control {

  $containers = hiera('containers')

  dc_docker::run { 'telemetry':
    * => $containers['telemetry']
  }

}
