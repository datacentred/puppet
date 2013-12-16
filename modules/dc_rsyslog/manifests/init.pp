# Class: dc_rsyslog
#
# Install, configure and ensure the service is running
#
class dc_rsyslog (
  $logstash_server = hiera(logstash_server),
  $logstash_port = 55514,
){
  class { 'dc_rsyslog::repo': } ~>
  class { 'dc_rsyslog::install': } ~> 
  class { 'dc_rsyslog::config': } ~>
  class { 'dc_rsyslog::service': } ~>
  Class['dc_rsyslog']
}
