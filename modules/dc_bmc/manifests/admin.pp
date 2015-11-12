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

  if (($::productname == 'X8DTT-H') or ($::productname == 'X9DRT')) {

    runonce { 'disable_sm_admin':
      command => "ipmitool user disable ${dc_bmc::ipmi_admin_user_slot}",
      require => Package['ipmitool'],
    }

    exec { 'create_sm_new_admin':
      command => "ipmitool user set name ${dc_bmc::ipmi_smnew_admin_user_slot} ${dc_bmc::bmc_admin_name}",
      unless  => "ipmitool user list ${dc_bmc::ipmi_user_channel} | grep -w ${dc_bmc::bmc_admin_name} | awk \'{print \$1}\' | grep ${dc_bmc::ipmi_smnew_admin_user_slot} >/dev/null",
      require => Package['ipmitool'],
    }

    runonce { 'set_sm_new_admin_passwd':
      command    => "ipmitool user set password ${dc_bmc::ipmi_smnew_admin_user_slot} ${dc_bmc::bmc_admin_passwd}",
      persistent => true,
      require    => Package['ipmitool'],
    }

    runonce { 'ipmi_sm_new_admin_access':
      command    => "ipmitool channel setaccess ${dc_bmc::ipmi_user_channel} ${dc_bmc::ipmi_smnew_admin_user_slot} link=on ipmi=on callin=on privilege=4",
      persistent => true,
      require    => Package['ipmitool'],
    }

    runonce { 'ipmi_sm_new_admin_enable':
      command    => "ipmitool user enable ${dc_bmc::ipmi_smnew_admin_user_slot}",
      persistent => true,
      require    => Package['ipmitool'],
    }

  } else {

    runonce { 'set_bmc_admin_passwd':
      command    => "ipmitool user set password ${dc_bmc::ipmi_admin_user_slot} ${dc_bmc::bmc_admin_passwd}",
      persistent => true,
      require    => Package['ipmitool'],
    }

    runonce { 'set_bmc_admin_name' :
      command    => "ipmitool user set name ${dc_bmc::ipmi_admin_user_slot} ${dc_bmc::bmc_admin_name}",
      persistent =>  true,
      require    => Package['ipmitool'],
    }

    runonce { 'enable_ipmi_admin_user':
      command    => "ipmitool user enable ${dc_bmc::ipmi_admin_user_slot}",
      persistent => true,
      require    => Package['ipmitool'],
    }

  }
}
