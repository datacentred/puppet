# Class: dc_logstash::server::courier
#
# Install the server side components of log-courier
#
class dc_logstash::server::courier {

  include dc_logstash::server

  $logcourier_plugin_version = $dc_logstash::server::logcourier_plugin_version

  exec { 'install_logcourier_plugin':
    command => "/opt/logstash/bin/logstash-plugin install --version ${logcourier_plugin_version} logstash-input-courier",
    unless  => "/opt/logstash/bin/logstash-plugin list --verbose | grep 'logstash-input-courier (${logcourier_plugin_version})'",
    require => Package['logstash'],
  } ~>

  Service['logstash']

}
