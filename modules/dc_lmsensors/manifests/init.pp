# Class: dc_lmsensors
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_lmsensors {

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

      # X8DTT-H = Compute / Storage nodes
      if $::boardproductname == 'X8DTT-H' {

          file { '/etc/sensors.d/jc42.conf':
            ensure  => 'file',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            source  => 'puppet:///modules/dc_lmsensors/jc42.conf',
            require => Package['lm-sensors'],
            notify  => Service['lm-sensors'],
          }

      }

      include dc_nrpe::sensors
      include dc_icinga::hostgroup_lmsensors
    }

    default: { }
  }

}


