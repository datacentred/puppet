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
    }
    'RedHat': {
      $pagerduty_deps = [
        'perl-Sys-Syslog',
        'perl-libwww-perl',
      ]
    }
    default: {
      $pagerduty_deps = []
    }
  }

  case $::operatingsystem {
    'Ubuntu': {
      $icon_image = 'http://incubator.storage.datacentred.io/ubuntu-logo-16x16.png'
    }
    'RedHat': {
      $icon_image = 'http://incubator.storage.datacentred.io/redhat-logo-16x16.png'
    }
    'Centos': {
      $icon_image = 'http://incubator.storage.datacentred.io/centos-logo-16x16.png'
    }
    'Fedora': {
      $icon_image = 'http://incubator.storage.datacentred.io/fedora-logo-16x16.png'
    }
    default: {
      $icon_image = undef
    }
  }

}
