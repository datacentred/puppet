# == Class: dc_profile::hardware::board_support
#
class dc_profile::hardware::board_support {

  # Manufacturer-dependant hardware classes
  case $::boardmanufacturer {
    'Supermicro': {
      case $::productname {
        'X8DTT-H': {
          include dc_icinga::hostgroup_supermicro
        }
        default: {
          include dc_icinga::hostgroup_supermicro_x9
        }
      }
    }
  }

}
