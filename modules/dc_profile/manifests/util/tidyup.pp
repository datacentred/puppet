# == Class: ::dc_profile::util::tidyup
#
# Uses the dc_tidy tidy wrapper to cleanup
# files (typically logfiles) listed in Hiera
#
class dc_profile::util::tidyup {

  create_resources(::dc_tidy, hiera(tidyup))

}
