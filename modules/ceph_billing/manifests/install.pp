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
    'curl',
    'python-mysqldb',
    'python-crypto',
  ]:
    ensure => installed,
  }

}
