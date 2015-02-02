# Class: dc_ipmi::params
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
class dc_ipmi::params (
  $ipmi_monitor_user,
  $ipmi_monitor_password,
  $ldap_server,
  $ldap_basedn,
  $ldap_port,
  $ldap_role_group,
){

  case $::productname {
    /ProLiant BL/: {
      $ipmi_user_channel = '2'
    }

    'X8DTT-H': {
      $ipmi_user_channel = '1'
    }

    /PowerEdge/: {
      $ipmi_user_channel = '1'
    }

    default: {
      $ipmi_user_channel = '1'
    }
  }

}
