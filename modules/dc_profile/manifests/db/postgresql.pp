# Class: dc_profile::db::postgresql
#
# Install a postgresql server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::db::postgresql {

  class { '::dc_postgresql': }

}
