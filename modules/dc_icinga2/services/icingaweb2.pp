# == Class: dc_icinga2::services::icingaweb2
#
# Checks icingaweb2 is responding
#
class dc_icinga2::services::icingaweb2 {

  tag $::fqdn, $::domain

  @@icinga2::object::service { "${::fqdn} icingaweb2":
    check_name    => 'icingaweb2',
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'enable_pagerduty' => true,
    },
  }

}
