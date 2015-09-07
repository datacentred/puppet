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
  $api_version = 1
  $grok_patterns_dir = '/etc/logstash/patterns/grok'

  # Log Courier options
  $logcourier_version = '1.1.28.gd11a1b4'
  $logcourier_port = '55516'
  $logcourier_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
  $logcourier_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
  $logcourier_cacert = '/var/lib/puppet/ssl/certs/ca.pem'
  $logcourier_server_version = '1.8.1'

  #Riemann options
  $riemann_plugin_version = '0.2.0'

  # Beaver options
  $beaver_port = '9999'

  # Syslog options
  $syslog_port = '5544'

  # Elasticsearch backend options
  $elasticsearch_host = 'elasticsearch'
  $elasticsearch_embedded = false
  $elasticsearch_protocol = 'http'

  # Generic client options
  $client_provider = 'log_courier'
  $client_version = $logcourier_version
  $client_server = 'logstash'
  $client_port = $logcourier_port
  $client_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
  $client_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
  $client_cacert = '/var/lib/puppet/ssl/certs/ca.pem'
  $client_timeout = '40'

}
