# Class: dc_role::hpblade
#
# Generic role picked up by the HP blades
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::hpblade inherits dc_role {

  contain dc_profile::hp::hpblade

}
