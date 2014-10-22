# Class: dc_role::puppetdb
#
# PuppetDB for store configs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::puppetdb inherits dc_role {

  contain dc_profile::puppet::puppetdb

}
