# Class: dc_logstash::server::courier
#
# Install the server side components of log-courier
#
class dc_logstash::server::courier {

  include dc_logstash::server

  Package['logstash'] ->

  exec { 'install_log_courier_gem':
    command => '/opt/logstash/bin/plugin install logstash-input-courier',
    unless  => '/opt/logstash/bin/plugin list | grep logstash-input-courier',
  } ->

  Service['logstash']

}
