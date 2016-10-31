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
      'http_clientcert'  => '/etc/puppetlabs/puppet/ssl/certs/$host.name$.pem',
      'http_privatekey'  => '/etc/puppetlabs/puppet/ssl/private_keys/$host.name$.pem',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "puppetdb"',
  }

  icinga2::object::apply_service { 'puppetdb dashboard':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_address' => '127.0.0.1',
      'http_port'    => 8080,
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

  # TODO: Add a service dependency between proxy -> dashboard

}
