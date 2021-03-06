# == Class: dc_icinga2::services::ceph
#
# Tests for all Ceph classes
#
class dc_icinga2::services::ceph {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  Icinga2::Object::Apply_service_for {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'ceph health':
    import        => 'generic-service',
    check_command => 'ceph-health',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_monitor"',
  }

  # Should only warn if == N/2+1 and crit if <= N/2
  icinga2::object::apply_service_for { 'ceph monitor':
    key           => 'interface',
    value         => 'attributes',
    hash          => 'host.vars.interfaces',
    import        => 'generic-service',
    check_command => 'ceph-mon',
    display_name  => 'ceph monitor',
    vars          => {
      'ceph_mon_monid'   => 'host.name.split(".").get(0)',
      'ceph_mon_monhost' => 'attributes.address',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_monitor" && attributes.cidr == "10.10.104.0/24"',
  }

  icinga2::object::apply_service_for { 'ceph osd':
    key           => 'interface',
    value         => 'attributes',
    hash          => 'host.vars.interfaces',
    import        => 'generic-service',
    check_command => 'ceph-osd',
    display_name  => 'ceph osd',
    vars          => {
      'ceph_osd_host'    => 'attributes.address',
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_osd" && attributes.cidr == "10.10.104.0/24"',
  }

  icinga2::object::apply_service { 'ceph radosgw':
    import        => 'generic-service',
    check_command => 'ceph-rgw',
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_radosgateway"',
  }

  icinga2::object::apply_service { 'ceph osd memory':
    import        => 'generic-service',
    check_command => 'ceph-memory',
    vars          => {
      'enable_pagerduty' => true,
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.role == "ceph_osd"',
  }

  icinga2::object::apply_service { 'ceph radosgw http':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 80,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "rados-endpoint"',
  }

  icinga2::object::apply_service { 'ceph radosgw https':
    import        => 'generic-service',
    check_command => 'http',
    vars          => {
      'http_port'        => 443,
      'http_ssl'         => true,
      'enable_pagerduty' => true,
    },
    assign_where  => 'host.vars.role == "rados-endpoint"',
  }

}
