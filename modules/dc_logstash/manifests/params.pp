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
  $logcourier_plugin_version = '1.9.0'
  $logcourier_port = '55516'

  if versioncmp($::puppetversion, '4.0.0') >= 0 {
    $logcourier_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"
    $logcourier_cert = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
    $logcourier_cacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
  } else {
    $logcourier_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem"
    $logcourier_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem"
    $logcourier_cacert = '/var/lib/puppet/ssl/certs/ca.pem'
  }

  # Riemann options
  $riemann_plugin_version = '2.0.5'

  # Syslog options
  $syslog_port = '5544'

  # Elasticsearch backend options
  $elasticsearch_hosts = ['elasticsearch']

}
