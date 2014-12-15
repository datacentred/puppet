# == Class: ceph_billing::install
#
class ceph_billing::install {

  package { 'python-pip':
    ensure => installed,
  } ->

  package { 'Django':
    ensure   => $ceph_billing::version,
    provider => 'pip',
  }

  package { [
    'python-mysqldb',
    'python-crypto',
  ]:
    ensure => installed,
  }

}
