# == Class: dc_icinga2::services::checkroutes
#
# Checks if certain routes are present on osnet0
#
class dc_icinga2::services::checkroutes {

  icinga2::object::apply_service { 'check routes':
    import        => 'openstack-service',
    check_command => 'checkroutes',
    vars          => {
      'enable_pagerduty'   => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.name == "osnet0.sal01.datacentred.co.uk"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
