# == Class: dc_icinga2
#
# Top level icinga2 role selection
#
class dc_icinga2 (
  $role = undef,
) {

  case $role {
    'master': {
      include ::dc_icinga2::master
    }
    'satellite': {
      include ::dc_icinga2::satellite
    }
    'none': {
      # do nothing!
    }
    default: {
      include ::dc_icinga2::agent
    }
  }

}
