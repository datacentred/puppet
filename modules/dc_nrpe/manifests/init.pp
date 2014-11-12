# Class: dc_nrpe
#
# Installs and configures nagios nrpe server
#
# Parameters:
#
# Actions:
#
# Requires: puppetlabs-xinetd
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
# FIXME add sudo support, add ability to add options
class dc_nrpe (
  $allowed_hosts = '127.0.0.1',
  $ensure_nagios = stopped,
){

  include ::dc_nrpe::install
  include ::dc_nrpe::configure
  include ::dc_nrpe::service

  Class['::dc_nrpe::install'] ->
  Class['::dc_nrpe::configure'] ~>
  Class['::dc_nrpe::service']

  # TODO: Move me!
  include ::dc_nrpe::glance
  include ::dc_nrpe::neutron
  include ::dc_nrpe::nova_server
  include ::dc_nrpe::logstash
  include ::dc_nrpe::smartd

}
