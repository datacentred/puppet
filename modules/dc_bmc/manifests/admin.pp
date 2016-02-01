# Class: dc_bmc::admin
#
# Configure the admin IPMI user
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
class dc_bmc::admin {

  ipmi_user { $::dc_bmc::bmc_admin_name:
    password  => $::dc_bmc::bmc_admin_passwd,
    privilege => 'administrator',
  }

}
