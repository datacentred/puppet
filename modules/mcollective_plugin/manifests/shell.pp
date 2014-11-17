# == Class: mcollective_plugin::shell
#
class mcollective_plugin::shell {

  package { 'mcollective-shell-agent':
    ensure => installed,
  }

}
