# Class: dc_profile::auth::radius::server
#
# Radius server§
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::auth::radius::server {
  include ::radius
  contain 'radius'
}