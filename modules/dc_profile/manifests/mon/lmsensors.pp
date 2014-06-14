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

      include dc_profile::util::semaphores

      package { 'lm-sensors':
        ensure => installed,
        notify => Exec['/usr/sbin/sensors-detect'],
      }

      exec { '/usr/sbin/sensors-detect':
        command     => "/usr/bin/yes YES | /usr/sbin/sensors-detect > ${dc_profile::util::semaphores::semaphores}/${title}",
        require     => Package['lm-sensors'],
        notify      => [ Service['lm-sensors'], Exec['module-init-tools'] ],
        creates     => "${dc_profile::util::semaphores::semaphores}/${title}",
        refreshonly => true,
      }

      exec { 'module-init-tools':
        command     => 'service module-init-tools restart',
        refreshonly => true,
      }

      service { 'lm-sensors':
        enable  => true,
        require => Package['lm-sensors'],
      }
    }

    default: { }
  }
}

