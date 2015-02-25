# Class: dc_pcs::netservices
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_pcs::netservices (
  $role,
  $loopback_store,
  $loopback_device,
  $drbd_device,
  $cluster_pair,
  $net_services_authkey,
  $net_services_vip,
){

  case $role {
    primary: {
      include dc_pcs::netservices::loopback
      include dc_pcs::netservices::primary_drbd
      include dc_pcs::netservices::corosync_install
      Class['dc_pcs::netservices::loopback'] -> Class['dc_pcs::netservices::primary_drbd'] -> Class['dc_pcs::netservices::corosync_install']
    }
    secondary: {
      include dc_pcs::netservices::loopback
      include dc_pcs::netservices::secondary_drbd
      include dc_pcs::netservices::corosync_install
      Class['dc_pcs::netservices::loopback'] -> Class['dc_pcs::netservices::secondary_drbd'] -> Class['dc_pcs::netservices::corosync_install']
    }
    default: { fail("role must be primary or secondary") }
  }

  stage { 'corosync_config': }
    Stage['main'] -> Stage['corosync_config']

  class { 'dc_pcs::netservices::corosync_config':
    stage =>  'corosync_config',
  }

}
