# Class: dc_branding::params
#
class dc_branding::params {

  case $::osfamily {
    'RedHat': {
      $http_service = 'httpd'
    }
    'Debian': {
      $http_service = 'apache2'
    }
    default: {}
  }

}
