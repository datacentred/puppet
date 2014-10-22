# Class: dc_role::foreman
#
# Foreman provisioning server role
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::foreman inherits dc_role {

  contain dc_profile::foreman::foreman

}
