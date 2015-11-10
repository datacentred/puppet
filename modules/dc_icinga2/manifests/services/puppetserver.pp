# == Class: profiles::icinga2::services::puppetserver
#
# Check Jenkins is running and responding to requests
#
class profiles::icinga2::services::puppetserver {

  tag $::fqdn, $::domain

  @@icinga2::object::service { "${::fqdn} puppetserver":
    check_name    => 'puppetserver',
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_uri'         => '/environment/status/name',
      'http_port'        => 8140,
      'http_ssl'         => true,
      'http_clientcert'  => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
      'http_privatekey'  => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
      'http_header'      => 'Accept: pson',
      'enable_pagerduty' => true,
    },
  }

}
