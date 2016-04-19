# == Class: dc_icinga2::services::ssl
#
# Checks for certificate expiry
#
class dc_icinga2::services::ssl {

  icinga2::object::apply_service_for { 'ssl-cert':
    key           => 'cn',
    value         => 'attributes',
    hash          => 'host.vars.certificates',
    import        => 'generic-service',
    check_command => 'ssl-cert',
    display_name  => '"ssl certificate " + cn',
    vars          => {
      'ssl_cert_port' => 'attributes.port',
      'ssl_cert_cn'   => 'cn',
    },
    assign_where  => 'host.vars.certificates',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
