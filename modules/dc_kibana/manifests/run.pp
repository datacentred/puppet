# == Class: dc_kibana::run
#
class dc_kibana::run {

  exec { 'run_kibana':
    command     => '/var/www/kibana/bin/kibana',
    cwd         => '/var/www',
    path        => ['/bin', '/usr/bin'],
    refreshonly => true
  }

}
