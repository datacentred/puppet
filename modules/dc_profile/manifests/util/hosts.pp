# Class: dc_profile::util::hosts
#
# Remove 127.0.1.1 if present
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::hosts {

  augeas { 'remove_loopback_etc_hosts':
    context => '/files/etc/hosts',
    changes => [
      "rm *[ipaddr = '127.0.1.1']",
    ],
  }

}
