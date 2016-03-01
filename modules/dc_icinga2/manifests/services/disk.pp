# == Class: dc_icinga2::services::disk
#
# Checks disk utilisation
#
class dc_icinga2::services::disk {

  icinga2::object::apply_service { 'disk':
    import        => 'generic-service',
    check_command => 'disk',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service_for { 'disk queue':
    key           => 'blockdevice',
    value         => 'attributes',
    hash          => 'host.vars.blockdevices',
    import        => 'generic-service',
    check_command => 'disk-queue',
    display_name  => '"disk queue " + blockdevice',
    vars          => {
      'disk_queue_device'   => 'blockdevice',
      'disk_queue_warning'  => '15,50',
      'disk_queue_critical' => '30,100',
    },
    zone          => 'host.name',
    assign_where  => true,
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
