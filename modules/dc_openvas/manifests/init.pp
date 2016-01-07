# Class: dc_openvas
#
# Installs and configures openvas scanner
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
class dc_openvas (
  $gsa_listen_address = $dc_openvas::params::gsa_listen_address,
  $gsa_listen_port    = $dc_openvas::params::gsa_listen_port,
  $gsa_user           = $dc_openvas::params::gsa_user,
  $gsa_password       = $dc_openvas::params::gsa_password,
  $scan_targets       = $dc_openvas::params::scan_targets,
) inherits dc_openvas::params {

  class { 'dc_openvas::install': } ->
  class { 'dc_openvas::config': } ->
  class { 'dc_openvas::service': }

}
