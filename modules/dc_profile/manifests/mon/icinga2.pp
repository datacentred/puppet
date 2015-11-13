# == Class: dc_profile::mon::icinga2
#
# Icinga 2 base profile for all machines
#
class dc_profile::mon::icinga2 {

  include ::dc_icinga2
  include ::dc_icinga2::services::generic
  include ::dc_icinga2::checks
  include ::dc_icinga2::groups
  include ::dc_icinga2::pagerduty
  include ::dc_icinga2::templates
  include ::dc_icinga2::timeperiods
  include ::dc_icinga2::users

}
