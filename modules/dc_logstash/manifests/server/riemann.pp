# Class: dc_logstash::server::riemann
#
# Install the server side components of riemann
#
class dc_logstash::server::riemann {

  include dc_logstash::server

  $riemann_plugin_version = $dc_logstash::server::riemann_plugin_version

  exec { 'install_riemann_plugin':
    command => "/opt/logstash/bin/logstash-plugin install --version ${riemann_plugin_version} logstash-output-riemann",
    unless  => "/opt/logstash/bin/logstash-plugin list --verbose | grep 'logstash-output-riemann (${riemann_plugin_version})'",
    require => Package['logstash'],
  } ~>

  Service['logstash']

}
