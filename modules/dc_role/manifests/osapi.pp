# Class: dc_role::osapi
#
# OpenStack API Front-End Server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::osapi {
  contain dc_profile::openstack::api
}
