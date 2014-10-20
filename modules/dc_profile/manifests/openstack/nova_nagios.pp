# Class: dc_profile::openstack::nova_nagios
#
# Nagios config for Nova controller node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::openstack::nova_nagios {

  include dc_icinga::hostgroup_nova_server
  include dc_nrpe::nova_server

}
