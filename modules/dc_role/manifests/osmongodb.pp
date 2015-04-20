# == Class: dc_role::osmongodb
#
# MongoDB deployment for OpenStack Ceilometer
#
class dc_role::osmongodb inherits dc_role {

  include ::dc_profile::openstack::mongodb
  contain ::dc_backup::duplicity
  contain ::dc_backup::gpg_keys

}
