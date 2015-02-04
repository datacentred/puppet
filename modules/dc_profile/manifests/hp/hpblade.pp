# Class: dc_profile::hp::hpblade
#
# Class to provision HP blades and modify
# chassis information via the ILO
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::hp::hpblade {

  # include dc_ipmi

  unless $::is_vagrant {
    include ::dc_icinga::hostgroup_hpblade
  }
}
