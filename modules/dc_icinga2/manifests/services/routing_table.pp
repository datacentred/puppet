# == Class: dc_icinga2::services::routing_table
#
# Checks for the presence of certain rules in the routing table
# of virtual routers
#
class dc_icinga2::services::routing_table (
  $routers_routes,
){
  icinga2::object::apply_service { 'routing_table':
    import        => 'openstack-service',
    check_command => 'routing_table',
    vars          => {
      'enable_pagerduty'             => true,
      'routing_table_routers_routes' => $routers_routes,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "openstack_network"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
