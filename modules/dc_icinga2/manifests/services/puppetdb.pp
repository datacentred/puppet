# == Class: profiles::icinga2::services::puppetdb
#
# Check PuppetDB is running and responding to requests
#
class profiles::icinga2::services::puppetdb {

  tag $::fqdn, $::domain

  @@icinga2::object::service { "${::fqdn} puppetdb":
    check_name    => 'puppetdb',
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_uri'         => '/v3/version',
      'http_port'        => 8081,
      'http_ssl'         => true,
      'http_clientcert'  => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
      'http_privatekey'  => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
      'enable_pagerduty' => true,
    },
  }

}
