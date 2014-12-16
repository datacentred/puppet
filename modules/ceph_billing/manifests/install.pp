# == Class: ceph_billing::install
#
class ceph_billing::install {

  $les_packages = [
    'python-pip',
    'python-mysqldb',
    'python-crypto',
    'curl',
  ]
  $les_valeurs_par_defaut_des_packages = {
    'ensure' => 'installed',
  }
  ensure_packages($les_packages, $les_valeurs_par_defaut_des_packages)

  package { 'Django':
    ensure   => $ceph_billing::version,
    provider => 'pip',
    require  => Package['python-pip'],
  }

}
