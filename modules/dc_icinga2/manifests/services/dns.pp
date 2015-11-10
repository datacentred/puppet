# == Class: profiles::icinga2::services::dns
#
# Monitor DNS services
#
class profiles::icinga2::services::dns {

  tag $::fqdn, $::domain

  @@icinga2::object::service { "${::fqdn} dns":
    check_name    => 'dns',
    import        => 'generic-service',
    check_command => 'dns',
    vars          => {
      'enable_pagerduty' => true,
    },
  }

}
