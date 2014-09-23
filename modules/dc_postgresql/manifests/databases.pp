# Class: dc_postgresql::databases
#
# Install the core databases
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
class dc_postgresql::databases {

  include ::dc_postgresql::params

  if $dc_postgresql::params::cluster_master_node == $::hostname {

    create_resources(postgresql::server::db, $dc_postgresql::params::databases)

  }
}
