# == Class: ceph_billing::install
#
class ceph_billing::install {

  $packages = [
    'python-pip',
    'python-mysqldb',
    'python-crypto',
    'curl',
  ]
  $package_defaults = {
    'ensure' => 'installed',
  }
  ensure_packages($packages, $package_defaults)

  package { 'Django':
    ensure   => $ceph_billing::version,
    provider => 'pip',
    require  => Package['python-pip'],
  }

}
