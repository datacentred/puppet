# == Class: dc_nrpe::checks::puppetdb
#
class dc_nrpe::checks::puppetdb {

  dc_nrpe::check { 'check_puppetdb':
    path => '/usr/lib/nagios/plugins/check_http',
    args => '-H localhost -p 8080',
  }

}
