# Class: dc_bmc::params
#
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
class dc_bmc::params {

  if $::productname == 'X8DTT-H' {
    $ipmi_smnew_admin_user_slot = '9'
  } else {
    $ipmi_smnew_admin_user_slot = undef
  }

  case $::productname {
    /ProLiant BL/: {
      $ipmi_user_channel = '2'
      $ipmi_admin_user_slot = '1'
    }

    'X8DTT-H': {
      $ipmi_user_channel = '1'
      $ipmi_admin_user_slot = '2'
    }

    /PowerEdge/: {
      $ipmi_user_channel = '1'
      $ipmi_admin_user_slot = '2'
    }

    default: {
      $ipmi_user_channel = '1'
      $ipmi_admin_user_slot = '1'
    }
  }

}
