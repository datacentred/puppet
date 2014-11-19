class dc_ipmi::dell::racadm {

  include dc_ipmi::dell::repos

  $idrac_packages = [
    'srvadmin-idrac',
    'srvadmin-idrac7',
    'srvadmin-idracadm7',
    'srvadmin-omilcore',
    'srvadmin-deng',
    'srvadmin-omcommon',
  ]
  package { $idrac_packages:
    ensure  => 'present',
    require => Class['dc_ipmi::dell::repos'],
  }
}