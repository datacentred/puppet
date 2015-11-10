# == Class: profiles::icinga2::services::jenkins
#
# Check Jenkins is running and responding to requests
#
class profiles::icinga2::services::jenkins {

  tag $::fqdn, $::domain

  @@icinga2::object::service { "${::fqdn} jenkins":
    check_name    => 'jenkins',
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 8080,
      'enable_pagerduty' => true,
    },
  }

}
