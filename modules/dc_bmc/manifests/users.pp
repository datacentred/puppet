# == Class: dc_bmc::users
#
# Default users to install on all systems
#
class dc_bmc::users {

  ipmi_user { $::dc_bmc::bmc_admin_name:
    password   => $::dc_bmc::bmc_admin_passwd,
    privilege  => 'administrator',
    ilo_name   => 'Administrator',
    ilo_admin  => true,
    ilo_remote => true,
    ilo_power  => true,
    ilo_media  => true,
    ilo_config => true,
  }

  ipmi_user { $::dc_bmc::ipmi_monitor_user:
    password => $dc_bmc::ipmi_monitor_password,
  }

}
