# Class: dc_postgresql::icinga
#
# Add monitoring configuration for icinga
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_postgresql::icinga {

  $icinga_ip = hiera(icinga_ip)

  # A test database for Nagios to probe
  dc_postgresql::db { 'nagiostest':
    user           => 'nagios',
    password       => 'nagios',
    access_address => "${icinga_ip}/32",
  }

}

