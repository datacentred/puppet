# == Class: dc_icinga2::services::conntrack
#
# Check connection tracking locally on each host
#
class dc_icinga2::services::conntrack {

  icinga2::object::apply_service { 'connection tracking':
    import        => 'openstack-service',
    check_command => 'conntrack',
    vars          => {
      'enable_pagerduty'   => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_compute" || host.vars.role == "openstack_network"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
