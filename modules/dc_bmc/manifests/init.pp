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
  $ipmi_monitor_user,
  $ipmi_monitor_password,
  $ipmi_monitor_user_slot,
  $ldap_server,
  $ldap_basedn,
  $ldap_port,
  $ldap_role_group,
  $ilo_net_settings_file,
  $ilo_net_settings_log,
  $radius_server,
  $radius_secret,
  $bmc_admin_passwd,
  $bmc_admin_name,
  $bmc_subnet,
  $bmc_netmask,
  $std_fw_version = $dc_bmc::params::std_fw_version,
  $ipmi_user_channel = $dc_bmc::params::ipmi_user_channel,
  $ipmi_admin_user_slot = $dc_bmc::params::ipmi_admin_user_slot,
  $ipmi_smnew_admin_user_slot = $dc_bmc::params::ipmi_smnew_admin_user_slot,
) inherits dc_bmc::params {

  $nameservers = hiera(nameservers)
  $ns_array = values($nameservers)
  $prim_dns = $ns_array[0]
  $sec_dns = $ns_array[1]
  $split_ip   = split($::ipaddress, '[.]')
  $bmc_ip = join(concat(delete_at(split($bmc_subnet, '[.]'), 3), [ $split_ip[3] ]), '.')
  $bmc_gateway = join(concat(delete_at(split($bmc_subnet, '[.]'), 3), [ '254' ]), '.')

  case $::productname {

    /ProLiant BL/: {
      include dc_bmc::base
      include dc_bmc::admin
      include dc_bmc::housekeeper
      include dc_bmc::hp::ilo
    }
    'X8DTT-H': {
      include dc_bmc::base
      include dc_bmc::admin
      include dc_bmc::housekeeper
      include dc_bmc::monitor_user
      include dc_bmc::supermicro::reaper
      include dc_bmc::supermicro::http_scripted
      include dc_bmc::supermicro::network
      Class['dc_bmc::supermicro::network'] -> Class['dc_bmc::supermicro::http_scripted']
    }
    /PowerEdge/: {
      include dc_bmc::base
      include dc_bmc::admin
      include dc_bmc::housekeeper
      include dc_bmc::monitor_user
      include dc_bmc::dell::idrac
    }
    default : {
      notify { "Unsupported IPMI platform ${::productname}": }
    }

  }

  stage{ 'post_config': }
  Stage['main'] -> Stage['post_config']

  class { dc_bmc::dns :
    stage => 'post_config',
  }

}
