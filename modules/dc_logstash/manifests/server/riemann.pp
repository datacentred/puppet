# Class: dc_logstash::server::riemann
#
# Install the server side components of riemann
#
class dc_logstash::server::riemann {

  include dc_logstash::server

  logstash::plugin { 'logstash-output-riemann': }

}
