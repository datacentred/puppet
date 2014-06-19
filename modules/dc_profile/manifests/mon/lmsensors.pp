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

      package { 'lm-sensors':
        ensure => installed,
      } ~>
      runonce { 'sensors-detect':
        command     => 'yes YES | sensors-detect',
        notify      => [ Service['lm-sensors'], Service['module-load'] ],
        refreshonly => true,
      }

      case $::lsbdistcodename {

        precise: {
          service { 'module-load':
            name   => 'module-init-tools',
            enable => false,
          }
        }
        default: {
          service { 'module-load':
            name   => 'kmod',
            enable => false,
          }
        }
      }

      service { 'lm-sensors':
        enable  => true,
        require => Package['lm-sensors'],
      }

      include dc_nrpe::sensors
      include dc_icinga::hostgroup_lmsensors
    }

    default: { }
  }
}

