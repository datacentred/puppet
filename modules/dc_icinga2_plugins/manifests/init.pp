# == Class: dc_icinga2_plugins
#
# Installs and manages bespoke icinga/nagios plugins
#
class dc_icinga2_plugins {

  # Load up modules by merging arrays from hiera
  $_modules = lookup('dc_icinga2_plugins::modules', Dc_icinga2_plugins::ModuleList, 'unique')

  contain $_modules

}
