# == Class: dc_icinga2::services::jenkins
#
# Check Jenkins is running and responding to requests
#
class dc_icinga2::services::jenkins {

  icinga2::object::service { 'jenkins':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8080,
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "jenkins"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
