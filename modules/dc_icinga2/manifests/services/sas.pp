# == Class: dc_icinga2::services::sas
#
# Service checks for Serial Attached SCSI storage networks
#
class dc_icinga2::services::sas {

  icinga2::object::apply_service { 'sas-phy':
    import        => 'generic-service',
    check_command => 'sas-phy',
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
