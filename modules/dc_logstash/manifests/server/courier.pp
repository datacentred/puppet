# Class: dc_logstash::server::courier
#
# Install the server side components of log-courier
#
class dc_logstash::server::courier (
  $logcourier_server_version = $dc_logstash::params::logcourier_server_version,
) inherits dc_logstash::params {

  include dc_logstash::server

  exec { 'install_log_courier_gem':
    command => "/opt/logstash/bin/plugin install --version ${logcourier_server_version} logstash-input-courier",
    unless  => "/opt/logstash/bin/plugin list | grep logstash-input-courier (${logcourier_server_version})",
    require => Package['logstash'],
  } ~>

  Service['logstash']

}
