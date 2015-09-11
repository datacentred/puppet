# Class: dc_logstash::server::courier
#
# Install the server side components of log-courier
#
class dc_logstash::server::courier {

  include dc_logstash::server

  $logcourier_server_version = $dc_logstash::server::logcourier_version

  exec { 'install_log_courier_gem':
    command => "/opt/logstash/bin/plugin install --version ${logcourier_server_version} logstash-input-courier",
    unless  => "/opt/logstash/bin/plugin list --verbose | grep logstash-input-courier (${logcourier_server_version})",
    require => Package['logstash'],
  } ~>

  Service['logstash']

}
