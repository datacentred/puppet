# == Class: dc_icinga2::services::canary_routers
#
# Checks if canary routers are present on the corrent nodes.
#
class dc_icinga2::services::canary_routers (
  $username,
  $password,
  $auth_url,
  $proj_name,
) {
  icinga2::object::apply_service { 'canary routers':
    import        => 'openstack-service',
    check_command => 'canary_routers',
    vars          => {
      'enable_pagerduty'         => true,
      'canary_routers_username'  => $username,
      'canary_routers_password'  => $password,
      'canary_routers_auth_url'  => $auth_url,
      'canary_routers_proj_name' => $proj_name,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "monitoring_master"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
