# Class: dc_profile::mon::lmsensors
#
# Installs lmsensors
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::mon::lmsensors {

  case $::virtual {

    physical: {

      case $::lsbdistcodename {
        'precise': {
          $sensor_service = 'module-init-tools'
        }
        default: {
          $sensor_service = 'kmod'
        }
      }

      package { 'lm-sensors':
        ensure => installed,
      } ->

      runonce { 'sensors-detect':
        command => 'yes YES | sensors-detect',
      } ->

      # Annoyingly these always get run if we use the puppet
      # service type, so run once per reboot
      runonce { 'sensors-module-load':
        command    => "service ${sensor_service} start",
        persistent => false,
      } ->

      service { 'lm-sensors':
        ensure  => running,
        enable  => true,
      }

      include dc_nrpe::sensors
      include dc_icinga::hostgroup_lmsensors
    }

    default: { }
  }
}

