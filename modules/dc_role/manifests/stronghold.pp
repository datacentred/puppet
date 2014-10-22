# Class: dc_role::stronghold
#
# Management console server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::stronghold inherits dc_role {

  contain dc_profile::rails::stronghold
}
