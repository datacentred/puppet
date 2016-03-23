# == Class: dc_icinga2::services::elasticsearch
#
# Checks Elasticsearch clusters and servers
#
class dc_icinga2::services::elasticsearch {

  icinga2::object::apply_service { 'elasticsearch':
    import        => 'generic-service',
    check_command => 'elasticsearch',
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "platform_elasticsearch"',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
