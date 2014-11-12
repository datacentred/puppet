class dc_profile::hardware::all {

  # Brand-dependant hardware classes
  if $::productname =~ /ProLiant BL/ {
    include dc_profile::hp::hpblade
  }

  # Manufacturer-dependant hardware classes
  case $::boardmanufacturer {
    'Supermicro': { include dc_profile::hardware::ipmi::supermicro }
    /Dell/:       { include dc_profile::hardware::ipmi::idrac }
  }
}