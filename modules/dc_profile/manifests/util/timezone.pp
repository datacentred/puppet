# Class: dc_profile::util::timezone
#
# Make sure the timezone is set correctly
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::util::timezone {

  file {'/etc/localtime':
    ensure => link,
    target => '/usr/share/zoneinfo/GB-Eire',
  }

  file {'/etc/timezone':
    content => "Europe/London\n",
  }
}
