# Class: dc_profile::openstack::cinder_nagios
#
# Nagios config for Cinder node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::cinder_nagios {

  include dc_icinga::hostgroup_cinder
  include dc_nrpe::cinder

}
