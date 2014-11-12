# == Class: dc_nrpe::install
#
class dc_nrpe::install {

  package { 'nagios-nrpe-server':
    ensure  => installed,
  }

}
