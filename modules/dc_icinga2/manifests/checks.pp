# == Class: dc_icinga2::checks
#
class dc_icinga2::checks {

  icinga2::object::checkcommand { 'memory':
    command   => 'PluginDir + "/check_memory"',
    arguments => {
      '-w' => '$memory_warn_bytes$',
      '-c' => '$memory_critical_bytes$',
      '-u' => '$memory_unit$',
      '-t' => '$memory_timeout$',
    },
    target    => '/etc/icinga2/zones.d/global-templates/checks.conf',
  }

}
