# Class: dc_logstash::server::riemann
#
# Install the server side components of riemann
#
class dc_logstash::server::riemann (
  $riemann_plugin_version = $dc_logstash::params::riemann_plugin_version,
) inherits dc_logstash::params {

  include dc_logstash::server

  exec { 'install_riemann_plugin':
    command => "/opt/logstash/bin/plugin install --version ${riemann_plugin_version} logstash-output-riemann",
    unless  => "/opt/logstash/bin/plugin list | grep logstash-output-riemann (${riemann_plugin_version})",
    require => Package['logstash'],
  } ~>

  Service['logstash']

}
