# == Class: dc_bmc::dell::idrac
#
# Configure LDAP authentication and hostname on Dell iDRAC
class dc_bmc::dell::idrac {

  include ::dc_bmc::dell::racadm
  include ::dc_bmc::dell::network
  include ::dc_bmc::dell::ldap

  Class['::dc_bmc::dell::racadm'] ->
  Class['::dc_bmc::dell::network'] ->
  Class['::dc_bmc::dell::ldap']

  # Workaround for Dell's broken package
  file { '/opt/dell/srvadmin/sbin/racadm-wrapper-idrac7':
    owner => 'root',
    group => 'root',
    mode  => '0755',
  } ->
  Drac_setting <||>

}
