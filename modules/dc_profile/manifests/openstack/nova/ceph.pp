#
# Class: dc_profile::openstack::nova::ceph
#
# Configure the Ceph RBD backend for compute nodes
#
class dc_profile::openstack::nova::ceph {

  include ::ceph
  include ::nova::compute::rbd

  # Ensure ceph is installed and configured before installing the cinder secret
  Class['::ceph'] -> Class['::nova::compute::rbd']

  # Make sure the Ceph client configuration is in place
  # before we do any of the Nova rbd-related configuration, and
  # restart if there's any changes
  Class['::ceph'] ~> Class['::nova::compute']
}
