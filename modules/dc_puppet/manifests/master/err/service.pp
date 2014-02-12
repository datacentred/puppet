#comment
class dc_puppet::master::err::service {

  service { 'err':
    ensure => running,
  }

}
