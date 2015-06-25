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

  case $::operatingsystem {
    'Ubuntu': {
      file { '/etc/resolvconf/resolv.conf.d/tail':
        content => "options timeout:1 attempts:2 rotate\n",
      } ~>
      exec { 'resolvconf -u':
        refreshonly => true,
      }
    }
    'RedHat', 'CentOS': {
      file_line { 'resolv_options':
        path => '/etc/resolv.conf',
        line => 'options timeout:1 attempts:2 rotate',
      }
    }
    default: {
      notify { 'Unsupported OS for dnsclient': }
    }
  }

}
