# == Class: dc_icinga2_plugins::params
#
class dc_icinga2_plugins::params {

  $packages = [
    'python-ceilometerclient',
    'python-cinderclient',
    'python-glanceclient',
    'python-keystoneclient',
    'python-novaclient',
    'python-pip',
    'python-dnspython',
    'nagios-plugin-check-scsi-smart',
    'python-tftpy',
  ]

  $pip_packages = [
    'ipaddress',
    'keystoneauth1',
    'python-heatclient',
  ]

}
