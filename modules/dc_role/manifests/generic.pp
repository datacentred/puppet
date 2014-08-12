# Class: dc_role::generic
#
# Generic role all servers possess
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::generic {

  include dc_profile::apt::apt
  include dc_profile::apt::dpkg
  include dc_profile::apt::repos
  include dc_profile::auth::rootpw

  contain dc_profile

}
