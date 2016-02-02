# == Class: dc_bmc::users
#
# Default users to install on all systems
#
class dc_bmc::users {

  # HP Proliant blades do not support link authentication
  if $::productname =~ /^ProLiant BL.*/ {
    Ipmi_user {
      link => false,
    }
  }

  ipmi_user { $::dc_bmc::bmc_admin_name:
    password  => $::dc_bmc::bmc_admin_passwd,
    privilege => 'administrator',
  }

  ipmi_user { $::dc_bmc::ipmi_monitor_user:
    password => $dc_bmc::ipmi_monitor_password,
  }

}
