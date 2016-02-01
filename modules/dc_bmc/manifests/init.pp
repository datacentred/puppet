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

  case $::productname {

    /ProLiant BL/: {
      include ::dc_bmc::base
      include ::dc_bmc::admin
      include ::dc_bmc::housekeeper
      include ::dc_bmc::hp
    }
    'X8DTT-H': {
      include ::dc_bmc::base
      include ::dc_bmc::admin
      include ::dc_bmc::housekeeper
      include ::dc_bmc::monitor_user
      include ::dc_bmc::supermicro::reaper
      include ::dc_bmc::supermicro::http_scripted
    }
    'X9DRT', 'X9DRD-7LN4F(-JBOD)/X9DRD-EF', 'SSG-6027R-E1R12L': {
      include ::dc_bmc::base
      include ::dc_bmc::admin
      include ::dc_bmc::housekeeper
      include ::dc_bmc::monitor_user
    }
    /PowerEdge/: {
      include ::dc_bmc::base
      include ::dc_bmc::admin
      include ::dc_bmc::housekeeper
      include ::dc_bmc::monitor_user
      include ::dc_bmc::dell::idrac
    }
    default : {
      notify { "Unsupported IPMI platform ${::productname}": }
    }

  }

}
