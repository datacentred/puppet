# Class: dc_role::platformservices_nova_mq
#
# Openstack Nova message queue
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::platformservices_nova_mq {

  contain dc_profile::openstack::nova_mq

}
