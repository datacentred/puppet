# Class: dc_profile::openstack::ceilometer::agent
#
# Ceilometer agent components for deployment on compute
# and network nodes.
#
# Parameters:
#
# Actions:
#
# Requires: StackForge Ceilometer
#
# Sample Usage:
#
class dc_profile::openstack::ceilometer::agent {

  include ::ceilometer
  include ::ceilometer::agent::auth
  include ::ceilometer::agent::compute

}
