# Class: dc_puppet::master::hipbot::install
#
# Hipbot installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::hipbot::install {

  Package {
    ensure => installed,
  }

  package { [
    'python-pip',
    'python-daemon',
    'python-pyasn1',
    'python-pyasn1-modules',
    ]:
  } ->

  package { 'sleekxmpp':
    provider => 'pip',
  }

}
