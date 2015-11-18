# == Class: dc_icinga2::services::puppetserver
#
# Check Jenkins is running and responding to requests
#
class dc_icinga2::services::puppetserver {

  icinga2::object::service { 'puppetserver':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_uri'         => '/environment/status/name',
      'http_port'        => 8140,
      'http_ssl'         => true,
      'http_clientcert'  => '/var/lib/puppet/ssl/certs/$host.name$.pem',
      'http_privatekey'  => '/var/lib/puppet/ssl/private_keys/$host.name$.pem',
      'http_header'      => 'Accept: pson',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'match("puppet_*, host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
