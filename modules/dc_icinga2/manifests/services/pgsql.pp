# == Class: dc_icinga2::services::pgsql
#
# Checks postgresql instances
#
class dc_icinga2::services::pgsql (
  $database = 'nagiostest',
  $username = 'nagios',
  $password = 'password',
) {

  icinga2::object::apply_service { 'pgsql':
    import        => 'generic-service',
    check_command => 'pgsql',
    vars          => {
      'pgsql_database' => $database,
      'pgsql_username' => $username,
      'pgsql_password' => $password,
    },
    zone          => 'host.name',
    assign_where  => 'match("postgresql_*", host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
