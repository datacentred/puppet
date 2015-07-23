# == Class: dc_dashing::service
#starts dashboard service
class dc_dashing::service {

  service { 'dashing':
    ensure  => running,
    start   => '/etc/init.d/dashing start',
    stop    => '/etc/init.d/dashing stop',
    restart => '/etc/init.d/dashing restart',
    status  => '/etc/init.d/dashing status',
  }
}
