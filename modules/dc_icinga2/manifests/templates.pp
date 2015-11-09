# == Class: dc_icinga2::templates
#
# Generic host and service templates
#
class dc_icinga2::templates {

  # Local host and service checks
  icinga2::object::template_host { 'generic-host':
    max_check_attempts => 3,
    check_interval     => '1m',
    retry_interval     => '30s',
    check_command      => 'hostalive',
  }

  icinga2::object::template_service { 'generic-service':
    max_check_attempts => 5,
    check_interval     => '1m',
    retry_interval     => '30s',
  }

  # Satellite host and service checks
  icinga2::object::template_host { 'satellite-host':  }

  icinga2::object::template_service { 'satellite-service': }

}
