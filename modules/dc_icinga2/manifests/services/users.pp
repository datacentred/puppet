# == Class: dc_icinga2::services::users
#
# Checks the number of users logged in
#
class dc_icinga2::services::users {

  icinga2::object::apply_service { 'users':
    import        => 'generic-service',
    check_command => 'users',
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'active users':
    import        => 'generic-service',
    check_command => 'active-users',
    vars          => {
      'active_users_no_tty_logins'   => true,
      'active_users_allowed_users'   => keys(hiera('admins')),
      'active_users_allowed_subnets' => '10.253.0.0/16',
    },
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
