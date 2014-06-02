# Class: dc_profile::db::coredb
#
# Install and maintain the core database
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::db::coredb {

  # SM - 20/02/2014
  # TODO: This is looking like a dc_postgresql module now as
  #       there is no hard coding, with the exception of the
  #       hiera tables names, which can always be made dyamic
  #       by doing hiera("${::hostname}_pg_blah")

  # Install the sever
  class { '::postgresql::server':
    ip_mask_allow_all_users    => hiera(postgresql_allow),
    ip_mask_deny_postgres_user => hiera(postgresql_deny),
    listen_addresses           => hiera(postgresql_listen),
    postgres_password          => hiera(postgresql_password),
  }

  # Create any databases
  create_resources(postgresql::server::db, hiera(postgresql_coredb))

  # Add configuration
  create_resources(postgresql::server::config_entry, hiera(postgresql_config))

  # And add in any monitoring
  include dc_icinga::hostgroup_postgres

}
