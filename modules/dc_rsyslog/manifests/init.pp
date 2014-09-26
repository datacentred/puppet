# Class: dc_rsyslog
#
# Install, configure and ensure the service is running
#
class dc_rsyslog (
  $logstash_server = '',
  $logstash_port,
){
  class { 'dc_rsyslog::install': } ~>
  class { 'dc_rsyslog::config': } ~>
  class { 'dc_rsyslog::service': } ~>
  Class['dc_rsyslog']
}
