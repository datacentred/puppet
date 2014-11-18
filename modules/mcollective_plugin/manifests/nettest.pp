# == Class: mcollective_plugin::nettest
#
class mcollective_plugin::nettest {

  package { 'mcollective-nettest-agent':
    ensure => installed,
  }

}
