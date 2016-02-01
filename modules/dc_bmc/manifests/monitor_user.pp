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

  ipmi_user { $::dc_bmc::ipmi_monitor_user:
    password => $dc_bmc::ipmi_monitor_password,
  }

}
