# Class: dc_puppet::master::hipbot::params
#
# Hipbot params
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::hipbot::params {

  case $::lsbdistcodename {
    'precise': {
      $debs = [
        'python-pip',
      ]
      $pips = [
        'pyasn1',
        'pyasn1-modules',
        'sleekxmpp'
      ]
    }
    'trusty': {
      $debs = [
        'python-pip',
        'python-pyasn1',
        'python-pyasn1-modules'
      ]
      $pips = [
        'sleekxmpp'
      ]
    }
    default: {
      crit('Unsupported distribution level')
    }
  }

}
