# == Class: dc_icinga2::services::puppetdb
#
# Check PuppetDB is running and responding to requests
#
class dc_icinga2::services::puppetdb {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'puppetdb':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_uri'         => '/v3/version',
      'http_port'        => 8081,
      'http_ssl'         => true,
      'http_clientcert'  => '/var/lib/puppet/ssl/certs/$host.name$.pem',
      'http_privatekey'  => '/var/lib/puppet/ssl/private_keys/$host.name$.pem',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "puppetdb"',
  }

  icinga2::object::apply_service { 'puppetdb dashboard':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port' => 8080,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "puppetdb"',
  }

  icinga2::object::apply_service { 'puppetdb dashboard reverse-proxy':
    import        => 'generic-service',
    check_command => 'http',
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "puppetdb"',
  }

}
