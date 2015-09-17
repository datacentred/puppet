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
class dc_logstash::params {

  # Generic options
  $grok_patterns_dir = '/etc/logstash/patterns/grok'

  # Log Courier options
  $logcourier_version_server = '1.8.1'
  $logcourier_port = '55516'
  $logcourier_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
  $logcourier_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
  $logcourier_cacert = '/var/lib/puppet/ssl/certs/ca.pem'

  # Riemann options
  $riemann_version = '0.2.0'

  # Syslog options
  $syslog_port = '5544'

  # Elasticsearch backend options
  $elasticsearch_host = 'elasticsearch'
  $elasticsearch_embedded = false
  $elasticsearch_protocol = 'http'

}
