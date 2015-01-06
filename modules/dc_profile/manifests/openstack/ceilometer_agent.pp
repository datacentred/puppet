# Class: dc_profile::openstack::ceilometer_agent
#
# OpenStack Ceilometer - cloud utilisation and monitoring
#
# Parameters:
#
# Actions:
#
# Requires: StackForge Ceilometer
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer_agent {

  include ::ceilometer
  include ::ceilometer::agent::auth
  include ::ceilometer::agent::compute

  # Explicitly enable mirrored queues.  This isn't set to true unless
  # rabbit_hosts is defined.
  ceilometer_config { 'DEFAULT/rabbit_ha_queues': value => true }

  unless $::is_vagrant {
    if $::environment == 'production' {
      include dc_logstash::client::ceilometer
    }
  }

}
