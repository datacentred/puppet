# == Class: dc_icinga2::services::users
#
# Checks the number of users logged in
#
class dc_icinga2::services::users {

  icinga2::object::service { 'users':
    import        => 'generic-service',
    check_command => 'users',
    zone          => 'host.name',
    assign_where  => 'host.name',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
