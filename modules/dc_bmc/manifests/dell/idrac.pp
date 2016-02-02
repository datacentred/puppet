# Class: dc_bmc::dell::idrac
#
# Configure LDAP authentication and hostname on DELL iDRAC
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
class dc_bmc::dell::idrac {

  # Install racadm and start dataeng service
  include ::dc_bmc::dell::racadm
  # Configure racadm network
  include ::dc_bmc::dell::network
  # Configure LDAP auth
  include ::dc_bmc::dell::ldap

  Class['::dc_bmc::dell::racadm'] ->
  Class['::dc_bmc::dell::network'] ->
  Class['::dc_bmc::dell::ldap']

}
