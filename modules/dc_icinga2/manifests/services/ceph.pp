# == Class: dc_icinga2::services::ceph
#
# Tests for all Ceph classes
#
class dc_icinga2::services::ceph {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'ceph health':
    import        => 'generic-service',
    check_command => 'ceph-health',
    vars          => {
      'ceph_health_detail' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_monitor"',
  }

  icinga2::object::apply_service { 'ceph monitor':
    import        => 'generic-service',
    check_command => 'ceph-mon',
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_monitor"',
  }

  icinga2::object::apply_service { 'ceph osd':
    import        => 'generic-service',
    check_command => 'ceph-osd',
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_osd"',
  }

  icinga2::object::apply_service { 'ceph radosgw':
    import        => 'generic-service',
    check_command => 'ceph-rgw',
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_radosgateway"',
  }

}
