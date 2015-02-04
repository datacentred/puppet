class dc_bmc::dell::racadm {

  include dc_bmc::dell::repos

  $idrac_packages = [
    #'srvadmin-all',
    'srvadmin-idrac',
    'srvadmin-idrac7',
    'srvadmin-idracadm7',
    'srvadmin-omilcore',
    'srvadmin-deng',
    'srvadmin-omcommon',
  ]

  package { $idrac_packages:
    ensure  => 'present',
    require => Class['dc_bmc::dell::repos'],
  }

  service { 'dataeng':
    ensure  => running,
    enable  => true,
    require => Package[$idrac_packages],
  }

  # Create a symlink to racadm in /usr/bin/racadm
  # because drac_setting expects it to be set
  file {'/usr/bin/racadm':
    ensure  => 'link',
    target  => '/opt/dell/srvadmin/sbin/racadm',
    require => Package[$idrac_packages],
  }

}
