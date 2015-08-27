# Class: dc_logstash::server::riemann
#
# Install the server side components of riemann
#
class dc_logstash::server::riemann {

  include dc_logstash::server

  Package['logstash'] ->

  exec { 'install_riemann_plugin':
    command     => '/opt/logstash/bin/plugin install logstash-output-riemann',
    unless      => '/opt/logstash/bin/plugin list | grep logstash-output-riemann',
  } ->

  Service['logstash']

}
