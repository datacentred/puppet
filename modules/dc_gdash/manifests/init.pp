# Class: dc_gdash
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_gdash (
  $graphite_server = undef,
  $gdash_root = undef,
) {

  include dc_gdash::params

  class { 'dc_gdash::install': } ~>
  class { 'dc_gdash::config': } ~>
  class { 'dc_gdash::dashboards': } ~>
  Class ['dc_gdash']

  Dc_gdash::Overview <<| |>>
  Dc_gdash::Nettraf <<| |>>
  Dc_gdash::Diskperf <<| |>>
  Dc_gdash::Df <<| |>>
  Dc_gdash::Cpu <<| |>>

}
