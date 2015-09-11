# Class: dc_logstash::server::riemann
#
# Install the server side components of riemann
#
class dc_logstash::server::riemann {

  include dc_logstash::server

  $riemann_version = $dc_logstash::server::riemann_version

  exec { 'install_riemann_plugin':
    command => "/opt/logstash/bin/plugin install --version ${riemann_version} logstash-output-riemann",
    unless  => "/opt/logstash/bin/plugin list --verbose | grep 'logstash-output-riemann (${riemann_version})'",
    require => Package['logstash'],
  } ~>

  Service['logstash']

}
