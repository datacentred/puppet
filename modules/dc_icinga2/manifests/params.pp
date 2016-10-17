# == Class: dc_icinga2::params
#
# Defines platform specific default configuration parameters
#
class dc_icinga2::params {

  case $::osfamily {
    'Debian': {
      if versioncmp($::operatingsystemrelease, '16.04') >= 0 {
        $pagerduty_deps = [
          'libperl5.22',
          'libwww-perl',
        ]
      } else {
        $pagerduty_deps = [
          'libsys-syslog-perl',
          'libwww-perl',
        ]
      }
      $user = 'nagios'
      $sudo_paths = '/usr/lib/nagios/plugins/*, /usr/local/lib/nagios/plugins/*, /usr/bin/cciss_vol_status'
    }
    'RedHat': {
      $pagerduty_deps = [
        'perl-Sys-Syslog',
        'perl-libwww-perl',
      ]
      $user = 'icinga'
      $sudo_paths = '/usr/lib64/nagios/plugins/*, /usr/local/lib/nagios/plugins/*, /usr/bin/cciss_vol_status'
    }
    default: {
      $pagerduty_deps = []
    }
  }

}
