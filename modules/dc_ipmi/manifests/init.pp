# Class: dc_ipmi
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
class dc_ipmi (
  $ipmi_monitor_user     = $dc_ipmi::params::ipmi_monitor_user,
  $ipmi_monitor_password = $dc_ipmi::params::ipmi_monitor_password,
  $ipmi_user_channel     = $dc_ipmi::params::ipmi_user_channel,
  $ipmi_user_slot        = $dc_ipmi::params::ipmi_user_slot,
  $ldap_server           = $dc_ipmi::params::ldap_server,
  $ldap_basedn           = $dc_ipmi::params::ldap_basedn,
  $ldap_port             = $dc_ipmi::params::ldap_port,
  $ldap_role_group       = $dc_ipmi::params::ldap_role_group,
) inherits dc_ipmi::params {

  # We want to load the kernel modules before installing the ipmi services
  include dc_ipmi::modules
  include dc_ipmi::install
  include dc_ipmi::config
  Class['dc_ipmi::modules'] -> Class ['dc_ipmi::install'] -> Class['dc_ipmi::config']

  # Set up a monitoring user
  include dc_ipmi::monitor_user

  # Dell specific code
  if $::boardmanufacturer =~ /Dell/ {
    include dc_ipmi::dell::idrac
  }

}
