# == Class: dc_icinga2::params
#
# Defines platform specific default configuration parameters
#
class dc_icinga2::params {

  case $::osfamily {
    'Debian': {
      $pagerduty_deps = [
        'libsys-syslog-perl',
        'libwww-perl',
      ]
      $user = 'nagios'
    }
    'RedHat': {
      $pagerduty_deps = [
        'perl-Sys-Syslog',
        'perl-libwww-perl',
      ]
      $user = 'icinga'
    }
    default: {
      $pagerduty_deps = []
    }
  }

}
