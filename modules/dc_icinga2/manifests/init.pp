# == Class: dc_icinga2
#
# Top level icinga2 role selection
#
class dc_icinga2 (
  $role = undef,
  $pagerduty_deps = $::dc_icinga2::params::pagerduty_deps,
  $user = $::dc_icinga2::params::user,
) inherits dc_icinga2::params {

  case $role {
    'master': {
      include ::dc_icinga2::master
    }
    'satellite': {
      include ::dc_icinga2::satellite
    }
    default: {
      include ::dc_icinga2::agent
    }
  }

}
