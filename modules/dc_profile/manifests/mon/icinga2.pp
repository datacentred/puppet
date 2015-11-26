# == Class: dc_profile::mon::icinga2
#
# Icinga 2 base profile for all machines
#
class dc_profile::mon::icinga2 {

  include ::dc_icinga2
  include ::dc_icinga2_plugins

  Class['::dc_icinga2_plugins'] ->
  Class['::dc_icinga2']

}
