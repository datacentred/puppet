#comment
class dc_puppetmaster::errbot::service {

  service { 'errbot':
    ensure => running,
  }

}
