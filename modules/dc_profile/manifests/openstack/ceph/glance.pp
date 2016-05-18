# == Class: dc_profile::openstack::ceph::glance
#
class dc_profile::openstack::ceph::glance {
  include ::glance::backend::rbd
}
