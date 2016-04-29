# == Class: dc_icinga2::services::bmc
#
# Perform BMC configration checks
#
# === Parameters
#
# [*username*]
#   User name to perform the check as
#
# [*password*]
#   User password to perform the check with
#
class dc_icinga2::services::bmc (
  $username,
  $password,
) {

  Icinga2::Object::Apply_service {
    target => '/etc/icinga2/zones.d/global-templates/services.conf',
  }

  icinga2::object::apply_service { 'bmc dns':
    import        => 'generic-service',
    check_command => 'bmc_dns',
    zone          => 'host.name',
    assign_where  => 'host.vars.operatingsystem',
    ignore_where  => 'host.vars.is_virtual || host.vars.productname == "OpenStack Nova"',
  }

  icinga2::object::apply_service { 'bmc R220':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '2.21',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "PowerEdge R220"',
  }

  icinga2::object::apply_service { 'bmc R420':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '2.20',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "PowerEdge R420"',
  }

  icinga2::object::apply_service { 'bmc BL460c G1':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '2.25',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "ProLiant BL460c G1"',
  }

  icinga2::object::apply_service { 'bmc BL465c G1':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '2.25',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "ProLiant BL465c G1"',
  }

  icinga2::object::apply_service { 'bmc X8DTT-H':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '2.20',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "X8DTT-H"',
  }

  icinga2::object::apply_service { 'bmc X9DRT':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '3.40',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "X9DRT"',
  }

  icinga2::object::apply_service { 'bmc X9DRD':
    import        => 'generic-service',
    check_command => 'bmc',
    vars          => {
      'bmc_host'     => 'host.vars.address_bmc',
      'bmc_username' => $username,
      'bmc_password' => $password,
      'bmc_revision' => '3.40',
    },
    zone          => 'host.name',
    assign_where  => 'host.vars.productname == "X9DRD-7LN4F(-JBOD)/X9DRD-EF"',
  }

}
