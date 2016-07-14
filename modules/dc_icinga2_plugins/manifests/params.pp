# == Class: dc_icinga2_plugins::params
#
class dc_icinga2_plugins::params {

  $basepackages = [
    'python-ceilometerclient',
    'python-cinderclient',
    'python-glanceclient',
    'python-keystoneclient',
    'python-novaclient',
    'python-pip',
  ]

  case $::operatingsystem {
    'Ubuntu', 'Debian': {
      $packages = concat($basepackages, 'python-dnspython', 'nagios-plugin-check-scsi-smart', 'python-tftpy')
    }
    'RedHat', 'CentOS': {
      $packages = concat($basepackages, 'python-dns')
    }
    default: {
      notify { 'Cannot determine packages - unsupported operating system!': }
    }
  }

  $pip_packages = [
    'ipaddress',
  ]

}
