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

  service { 'icinga':
    ensure => running,
  }

}
