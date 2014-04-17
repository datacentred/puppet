# Class: dc_ceph
#
# Must be included on all nodes, installs the packages and
# fills in the configuration file.  Concrete classes of
# ceph nodes must depend on this one
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_ceph {

  # Monitors export themselves for global collection to allow
  # elasticity, to facilitate provisioning in the first place
  # default to local hostname and ip address

  $mon_member_list = get_exported_var('', 'ceph_mon_initial_members', $::hostname)
  if is_array($mon_member_list) {
    $mon_member_string = join($mon_member_list, ',')
  } else {
    $mon_member_string = $mon_member_list
  }

  $mon_host_list = get_exported_var('', 'ceph_mon_host', $::ipaddress)
  if is_array($mon_host_list) {
    $mon_host_string = join($mon_host_list, ',')
  } else {
    $mon_host_string = $mon_host_list
  }

  # Additional static parameters are defined in hiera

  class { 'ceph':
    mon_initial_members => $mon_member_string,
    mon_host            => $mon_host_string,
  }
  contain 'ceph'

}
