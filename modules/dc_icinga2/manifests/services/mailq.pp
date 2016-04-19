# == Class: dc_icinga2::services::mailq
#
# Checks the mail queue depth.  Errors on clients suggest they can't
# contact the MX, errors on the MXes suggest Google is down or
# throttling and the service is degraded
#
# === Notes
#
# Gateways are excluded as they run the SMTP port to proxy for the
# MX boxes, and can't run a local MTU
#
class dc_icinga2::services::mailq {

  icinga2::object::apply_service { 'mailq':
    import        => 'generic-service',
    check_command => 'mailq',
    vars          => {
      'mailq_warning'    => 50,
      'mailq_critical'   => 100,
      'mailq_servertype' => 'postfix',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.os',
    target        => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

}
