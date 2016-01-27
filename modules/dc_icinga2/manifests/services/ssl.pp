# == Class: dc_icinga2::services::ssl
#
# Checks for certificate expiry
#
class dc_icinga2::services::ssl {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { '*.datacentred.io certificate':
    import        => 'generic-service',
    check_command => 'ssl-cert',
    vars          => {
      'ssl_cert_host' => 'compute.datacentred.io',
      'ssl_cert_cn'   => '*.datacentred.io',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { '*.storage.datacentred.io certificate':
    import        => 'generic-service',
    check_command => 'ssl-cert',
    vars          => {
      'ssl_cert_host' => 'storage.datacentred.io',
      'ssl_cert_cn'   => '*.storage.datacentred.io',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

  icinga2::object::apply_service { '*.datacentred.services certificate':
    import        => 'generic-service',
    check_command => 'ssl-cert',
    vars          => {
      'ssl_cert_host' => 'jenkins.datacentred.services',
      'ssl_cert_port' => 8080,
      'ssl_cert_cn'   => '*.datacentred.services',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
  }

}
