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
  $ipmi_user_channel = $dc_bmc::params::ipmi_user_channel,
  $ipmi_admin_user_slot = $dc_bmc::params::ipmi_admin_user_slot,
  $ipmi_smnew_admin_user_slot = $dc_bmc::params::ipmi_smnew_admin_user_slot,
  $omapi_key = undef,
  $omapi_secret = undef,
  $omapi_host = undef,
  $omapi_port = undef,
  $bmc_subnet = undef,
  $foreman_url = undef,
  $foreman_admin_user = undef,
  $foreman_admin_passwd = undef,
) inherits dc_bmc::params {

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
    'X9DRT': {
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
