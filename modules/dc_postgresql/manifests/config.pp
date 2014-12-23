class dc_postgresql::config {

  include ::dc_postgresql::params

  create_resources('postgresql::server::config_entry', $dc_postgresql::params::config_entries)

}
