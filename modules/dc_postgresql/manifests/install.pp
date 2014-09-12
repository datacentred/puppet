# Class: dc_postgresql::install
#
# Install the server
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
class dc_postgresql::install {

  include ::dc_postgresql::params

  # Install the server to listen on the chosen address range
  class { '::postgresql::server':
    ip_mask_allow_all_users    => $dc_postgresql::params::ip_mask_allow_all_users,
    ip_mask_deny_postgres_user => $dc_postgresql::params::ip_mask_deny_postgres_user,
    listen_addresses           => $dc_postgresql::params::listen_addresses,
    postgres_password          => $dc_postgresql::params::postgres_password,
  }

  package { 'postgresql-contrib':
    ensure => installed,
  }

}
