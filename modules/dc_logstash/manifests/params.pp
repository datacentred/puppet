# Class: dc_logstash::params
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_logstash::params (
  $logstash_server,
  $logstash_syslog_port,
  $logcourier_port,
  $logcourier_version,
  $logstash_grok_patterns_dir,
  $logstash_cert_alias,
  $riemann_dev_host,
  $elasticsearch_host,
  $elasticsearch_embedded,
  $elasticsearch_protocol,
){}
