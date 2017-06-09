# Class: dc_logstash::server::beats
#
# Install the server side components of file beats
#
class dc_logstash::server::beats {

  include dc_logstash::server

  logstash::plugin { 'logstash-input-beats': }

}
