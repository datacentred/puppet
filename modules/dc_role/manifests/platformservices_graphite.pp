# Class: dc_role::platformservices_graphite
#
# Realtime graph plotting role
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::platformservices_graphite {

  contain dc_profile::graphite
  contain dc_profile::gdash

}
