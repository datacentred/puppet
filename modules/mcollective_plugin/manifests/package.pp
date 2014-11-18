# == Class: mcollective_plugin::package
#
class mcollective_plugin::package {

  package { 'mcollective-package-agent':
    ensure => installed,
  }

}
