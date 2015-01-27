# Class: dc_profile::log::riemann
#
# Installs riemann and a basic email output stream
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::riemann{

  class { 'dc_riemann': }

}
