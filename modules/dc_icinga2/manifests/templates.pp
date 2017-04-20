# == Class: dc_icinga2::templates
#
# Generic host and service templates.  The master node uses the master-host
# template as a dummy hostalive check.  All other nodes are checked with
# the cluster-zone check from their parent to ascertain liveness.
#
class dc_icinga2::templates {

  icinga2::object::template_host { 'master-host':
    max_check_attempts => 3,
    check_interval     => '1m',
    retry_interval     => '30s',
    check_command      => 'hostalive',
    target             => '/etc/icinga2/zones.d/global-templates/templates.conf',
  }

  icinga2::object::template_host { 'satellite-host':
    max_check_attempts => 3,
    check_interval     => '1m',
    retry_interval     => '30s',
    check_command      => 'cluster-zone',
    target             => '/etc/icinga2/zones.d/global-templates/templates.conf',
  }

  icinga2::object::template_service { 'generic-service':
    max_check_attempts => 5,
    check_interval     => '1m',
    retry_interval     => '30s',
    target             => '/etc/icinga2/zones.d/global-templates/templates.conf',
  }

  icinga2::object::template_service { 'openstack-service':
    max_check_attempts => 3,
    check_interval     => '5m',
    retry_interval     => '5m',
    target             => '/etc/icinga2/zones.d/global-templates/templates.conf',
  }

  icinga2::object::template_service { 'daily-service':
    max_check_attempts => 3,
    check_interval     => '1d',
    retry_interval     => '1h',
    target             => '/etc/icinga2/zones.d/global-templates/templates.conf',
  }

  icinga2::object::template_host { 'virtual-host':
    max_check_attempts => 3,
    check_interval     => '1m',
    retry_interval     => '30s',
    check_command      => 'hostalive',
    target             => '/etc/icinga2/zones.d/global-templates/templates.conf',
  }

}
