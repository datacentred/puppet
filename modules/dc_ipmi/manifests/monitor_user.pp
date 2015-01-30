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
class dc_ipmi::monitor_user{

  exec { 'ipmi_monitor_user' :
    command   => "ipmitool user set name ${dc_ipmi::ipmi_user_slot} ${dc_ipmi::ipmi_monitor_user}",
    onlyif    => "test \"$(ipmitool user list ${dc_ipmi::ipmi_user_channel} |tail -1 |awk \'{print \$2}\')\" == \"${dc_ipmi::ipmi_monitor_user}\"",
    logoutput => true,
    require   => Package['ipmitool'],
  }

  exec { 'ipmi_monitor_password' :
    command     => "ipmitool user set password ${dc_ipmi::ipmi_user_slot} ${dc_ipmi::ipmi_monitor_password}",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

  exec { 'ipmi_monitor_access':
    command     => "ipmitool channel setaccess ${dc_ipmi::ipmi_user_channel} ${dc_ipmi::ipmi_user_slot} link=on ipmi=on callin=on privilege=2",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

  exec { 'ipmi_monitor_enable':
    command     => "ipmitool user enable ${dc_ipmi::ipmi_user_slot}",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

}
