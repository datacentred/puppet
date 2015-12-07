# Class: dc_haproxy
#
class dc_haproxy {

  file { '/opt/haproxy':
    ensure => directory,
  }

}
