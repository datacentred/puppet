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
  $gdash_root = undef,
) inherits dc_gdash::params {

  class { 'dc_gdash::install': } ~>
  class { 'dc_gdash::config': } ~>
  class { 'dc_gdash::dashing': } ~>
  Class ['dc_gdash']

}
