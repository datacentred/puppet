# Class: dc_puppet::master::err::install
#
# Errbot installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::err::install {

  package { [
    'python-pip',
    'python-dev'
  ]:
    ensure => installed,
  }

  package { [
    'err',
    'sleekxmpp',
    'pyasn1',
    'pyasn1_modules',
    '3to2',
    'daemonize',
    'markupsafe'
  ]:
    ensure   => installed,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  Package['3to2'] -> Package['err']
  Package['python-dev'] -> Package['err']

}
