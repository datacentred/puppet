# == Class: dc_icinga2::services::smart
#
# Perform SMART checks on SATA disks
#
# === Description
#
# Performs SMART checks on SATA disks by tunnelling ATA commands over
# SCSI transport.  The commands are decoded at the relevant boundary
# between SCSI and ATA as described in the T10 SAT specification.
#
# Checks on HP and Dell RAID hardware pass transparently as the SMART
# feature set is not supported on these block devices.
#
class dc_icinga2::services::smart {

  icinga2::object::apply_service_for { 'smart':
    key           => 'blockdevice',
    value         => 'attributes',
    hash          => 'host.vars.blockdevices',
    import        => 'generic-service',
    check_command => 'smart',
    display_name  => '"smart " + blockdevice',
    vars          => {
      'smart_device'  => 'attributes.path',
      'smart_warning' => '5:1',
    },
    zone          => 'host.name',
    assign_where  => 'match("sd*", blockdevice)',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
