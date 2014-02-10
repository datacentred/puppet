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
  Class ['dc_gdash']
}
