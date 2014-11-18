# == Class: mcollective_plugin::service
#
class mcollective_plugin::service {

  package { 'mcollective-service-agent':
    ensure => installed,
  }

}
