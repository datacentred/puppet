# Class:
#
# Ensures the icinga service is running on the server node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_icinga::server::service {

  service { 'nagios3':
    ensure => stopped,
  }

  service { 'icinga':
    ensure => running,
  }

}
