# Class: dc_bmc::monitor_user
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
class dc_bmc::monitor_user{

  exec { 'ipmi_monitor_user' :
    command   => "ipmitool user set name ${dc_bmc::ipmi_monitor_user_slot} ${dc_bmc::ipmi_monitor_user}",
    unless    => "ipmitool user list ${dc_bmc::ipmi_user_channel} | awk \'{print \$2}\' | grep ${dc_bmc::ipmi_monitor_user} >/dev/null",
    logoutput => true,
    require   => Package['ipmitool'],
  }

  exec { 'ipmi_monitor_password' :
    command     => "ipmitool user set password ${dc_bmc::ipmi_monitor_user_slot} ${dc_bmc::ipmi_monitor_password}",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

  exec { 'ipmi_monitor_access':
    command     => "ipmitool channel setaccess ${dc_bmc::ipmi_user_channel} ${dc_bmc::ipmi_monitor_user_slot} link=on ipmi=on callin=on privilege=2",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

  exec { 'ipmi_monitor_enable':
    command     => "ipmitool user enable ${dc_bmc::ipmi_monitor_user_slot}",
    refreshonly => true,
    logoutput   => false,
    subscribe   => Exec['ipmi_monitor_user'],
  }

}
