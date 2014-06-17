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
        notify      => [ Service['lm-sensors'], Service['module-init-tools'] ],
        refreshonly => true,
      }

      service { 'module-init-tools':
        enable      => false,
      }

      service { 'lm-sensors':
        enable  => true,
        require => Package['lm-sensors'],
      }
    }

    default: { }
  }
}

