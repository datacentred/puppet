# Installs racadm
class dc_bmc::dell::racadm {

  $idrac_packages = [
    'srvadmin-idracadm7',
    'srvadmin-omilcore',
    'srvadmin-deng',
    'srvadmin-omcommon',
  ]

  package { $idrac_packages:
    ensure => present,
  } ->

  # Create a symlink to racadm in /usr/bin/racadm
  # because drac_setting expects it to be set
  file {'/usr/bin/racadm':
    ensure => link,
    target => '/opt/dell/srvadmin/sbin/racadm',
  } ->

  service { 'dataeng':
    ensure => running,
    enable => true,
  }

}
