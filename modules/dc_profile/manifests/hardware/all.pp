# == Class: dc_profile::hardware::all
#
class dc_profile::hardware::all {

  # Brand-dependant hardware classes
  if $::productname =~ /ProLiant BL/ {
    include dc_profile::hp::hpblade
  }

  # Manufacturer-dependant hardware classes
  case $::boardmanufacturer {
    'Supermicro': {
      include dc_ipmi::supermicro::ipmi
      include dc_ipmi::supermicro::reaper
    }
    /Dell/:       { include dc_ipmi::dell::idrac }
  }
}
