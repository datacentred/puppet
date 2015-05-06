# == Class: dc_profile::hardware::board_support
#
class dc_profile::hardware::board_support {

  # Manufacturer-dependant hardware classes
  case $::boardmanufacturer {
    'Supermicro': {
      include dc_icinga::hostgroup_supermicro
    }
  }

}
