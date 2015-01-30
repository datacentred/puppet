# Class: dc_ipmi::monitor_user
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
class dc_ipmi::monitor_user(
  $ipmi_monitor_user,
  $ipmi_monitor_password,
){

  exec { 'ipmi_monitor_user' :
    command   => "ipmitool user set name 10 ${ipmi_monitor_user}",
    onlyif    => "test \"$(ipmitool user list 1 |tail -1 |awk \'{print \$2}\')\" == \"${ipmi_monitor_user}\"",
    logoutput => true,
  }

  exec { 'ipmi_monitor_password' :
    command     => "ipmitool user set password 10 ${ipmi_monitor_password}",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

  exec { 'ipmi_monitor_access':
    command     => 'ipmitool channel setaccess 1 10 link=on ipmi=on callin=on privilege=2',
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

  exec { 'ipmi_monitor_enable':
    command     => 'ipmitool user enable 10',
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

}
