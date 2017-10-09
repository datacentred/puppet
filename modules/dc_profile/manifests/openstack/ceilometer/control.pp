# Class: dc_profile::openstack::ceilometer::control
#
# Main Ceilometer components for deployment on a cloud control node
#
class dc_profile::openstack::ceilometer::control {

  $containers = hiera_hash('containers')

  dc_docker::run { 'ceilometer':
    * => $containers['ceilometer']
  }

  dc_docker::logrotate { 'ceilometer': }

}
