# == Class: dc_icinga2::services::pgsql_replication
#
# Checks replicated postgresql instances
#
class dc_icinga2::services::pgsql_replication (
  $password = 'password',
) {

  icinga2::object::apply_service { 'pgsql replication':
    import        => 'generic-service',
    check_command => 'pgsql_replication',
    vars          => {
      'pgsql_replication_password' => $password,
      'pgsql_replication_warning'  => 10485100,
      'pgsql_replication_critical' => 104851000,
    },
    zone          => 'host.name',
    assign_where  => 'match("postgresql_*", host.vars.role)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
