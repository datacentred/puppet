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

  $beats_port = '5504'

  $beats_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem"
  $beats_cert = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem"
  $beats_cacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'

  # Riemann options
  $riemann_plugin_version = '2.0.5'

  # Syslog options
  $syslog_port = '5544'

  # Elasticsearch backend options
  $elasticsearch_hosts = ['elasticsearch']

}
