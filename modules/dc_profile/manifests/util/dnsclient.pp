# Class: dc_profile::util::dnsclient
#
# Manages /etc/resolv.conf
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class dc_profile::util::dnsclient {
  file { '/etc/resolvconf/resolv.conf.d/tail':
    content => "options timeout:1 attempts:2 rotate\n",
  } ~>
  exec { 'resolvconf -u':
    refreshonly => true,
  }
}
