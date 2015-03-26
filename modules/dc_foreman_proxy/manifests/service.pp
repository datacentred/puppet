# Class: dc_foreman_proxy::service
#
# Foreman_proxy service class
#
# Parameters:
#
# Actions:
#
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_foreman_proxy::service {

  service { 'foreman-proxy':
    ensure  => running,
    require => Package['foreman-proxy'],
    enable  => true,
  }

}
