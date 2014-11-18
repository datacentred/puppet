# == Class: mcollective_plugin::nrpe
#
class mcollective_plugin::nrpe {

  package { 'mcollective-nrpe-agent':
    ensure => installed,
  }

}
