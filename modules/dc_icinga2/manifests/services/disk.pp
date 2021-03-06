# == Class: dc_icinga2::services::disk
#
# Checks disk utilisation
#
class dc_icinga2::services::disk {

  icinga2::object::apply_service_for { 'file system':
    key           => 'mountpoint',
    value         => 'attributes',
    hash          => 'host.vars.mountpoints',
    import        => 'generic-service',
    check_command => 'disk',
    display_name  => '"file system " + mountpoint',
    vars          => {
      'disk_partitions'  => 'mountpoint',
      'enable_pagerduty' => true,
      'instance'         => 'mountpoint',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    ignore_where  => 'host.vars.role == "netflow_monitoring" && mountpoint.contains("flowdata")',
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
      'disk_queue_average'  => '5',
      'disk_queue_warning'  => '60',
      'disk_queue_critical' => '80',
      'instance'            => 'blockdevice',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service_for { 'disk latency':
    key           => 'blockdevice',
    value         => 'attributes',
    hash          => 'host.vars.blockdevices',
    import        => 'generic-service',
    check_command => 'disk-latency',
    display_name  => '"disk latency " + blockdevice',
    vars          => {
      'disk_latency_device'   => 'blockdevice',
      'disk_latency_warning'  => [ 1000, 1000, 250, 250 ],
      'disk_latency_critical' => [ 2000, 2000, 500, 500 ],
      'instance'              => 'blockdevice',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
