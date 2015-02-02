# Class: dc_ipmi::dell::idrac
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
class dc_ipmi::dell::idrac {

  # Install racadm and start dataeng service
  include dc_ipmi::dell::racadm
  # Configure racadm
  include dc_ipmi::dell::config
  Class['dc_ipmi::dell::racadm'] -> Class['dc_ipmi::dell::config']

}
