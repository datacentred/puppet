# Class: dc_bmc
#
# It ensures that ipmitool and utils are installed and relevant kernel modules are
# loaded.
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
class dc_bmc (
  $ipmi_monitor_user = undef,
  $ipmi_monitor_password = undef,
  $ipmi_monitor_user_slot = undef,
  $ldap_server = undef,
  $ldap_basedn = undef,
  $ldap_port = undef,
  $ldap_role_group = undef,
  $ilo_net_settings_file = undef,
  $ilo_net_settings_log = undef,
  $radius_server = undef,
  $radius_secret = undef,
  $bmc_admin_passwd = undef,
  $bmc_admin_name = undef,
) {

  case $::osfamily {
    'Debian': {
      include ::dc_bmc::debian
    }
    default: {
      # Stop compiler warnings
    }
  }

  include ::dc_bmc::users
  include ::dc_bmc::housekeeper

  case $::productname {

    /ProLiant BL/: {
      include ::dc_bmc::hp
    }
    'X8DTT-H': {
      include ::dc_bmc::supermicro::reaper
      include ::dc_bmc::supermicro::http_scripted

      # Ensure the admin user is installed before trying to screen-scrape...
      Class['::dc_bmc::users'] -> Class['::dc_bmc::supermicro::http_scripted']
    }
    /PowerEdge/: {
      include ::dc_bmc::dell::idrac
    }
    default: {
      # Stop compiler warnings
    }

  }

}
