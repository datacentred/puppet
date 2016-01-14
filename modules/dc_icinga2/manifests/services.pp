# == Class: dc_icinga2::services
#
# Defines all icinga2 service templates
#
class dc_icinga2::services {

  include ::dc_icinga2::services::bmc
  include ::dc_icinga2::services::ceph
  include ::dc_icinga2::services::disk
  include ::dc_icinga2::services::dns
  include ::dc_icinga2::services::icingaweb2
  include ::dc_icinga2::services::jenkins
  include ::dc_icinga2::services::load
  include ::dc_icinga2::services::memory
  include ::dc_icinga2::services::procs
  include ::dc_icinga2::services::psu
  include ::dc_icinga2::services::puppetdb
  include ::dc_icinga2::services::puppetserver
  include ::dc_icinga2::services::sensors
  include ::dc_icinga2::services::smart
  include ::dc_icinga2::services::ssh
  include ::dc_icinga2::services::users

}
