# Class: dc_profile::openstack::ceilometer::control
#
# Main Ceilometer components for deployment on a cloud control node
#
class dc_profile::openstack::ceilometer::control {

  $containers = hiera('containers')

  dc_docker::run { 'telemetry':
    * => $containers['telemetry']
  }

  ensure_packages([ 'ceilometer-agent-central', 'ceilometer-agent-notification',
                    'ceilometer-api', 'ceilometer-common', 'ceilometer-collector',
                    'ceilometer-alarm-evaluator', 'ceilometer-alarm-notifier'],
                    { ensure => purged })
}
