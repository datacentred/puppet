# == Class: dc_icinga2::checks
#
class dc_icinga2::checks {

  Icinga2::Object::Checkcommand {
    target => '/etc/icinga2/zones.d/global-templates/checks.conf',
  }

  icinga2::object::checkcommand { 'memory':
    command   => 'PluginDir + "/check_memory"',
    arguments => {
      '-w' => '$memory_warn_bytes$',
      '-c' => '$memory_critical_bytes$',
      '-u' => '$memory_unit$',
      '-t' => '$memory_timeout$',
    },
  }

  icinga2::object::checkcommand { 'bmc':
    command   => '"/usr/local/lib/nagios/plugins/check_bmc"',
    arguments => {
      '-H' => '$bmc_host$',
      '-u' => '$bmc_username$',
      '-p' => '$bmc_password$',
      '-r' => '$bmc_revision$',
    },
  }

}
