# == Class: dc_profile::openstack::cinder
#
# Configure OpenStack's block storage service
#
# NB: Ceph client configuration lives in a seperate profile class
#
class dc_profile::openstack::cinder {

  include ::cinder
  include ::cinder::keystone::auth
  include ::cinder::api
  include ::cinder::scheduler
  include ::cinder::glance
  include ::cinder::quota
  include ::cinder::volume
  include ::cinder::backends
  include ::cinder::ceilometer
  include ::cinder::config
  include ::dc_icinga::hostgroup_cinder

}
