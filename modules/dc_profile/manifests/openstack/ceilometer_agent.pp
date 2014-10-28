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

}
