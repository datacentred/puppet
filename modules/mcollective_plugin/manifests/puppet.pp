# == Class: mcollective_plugin::puppet
#
class mcollective_plugin::puppet {

  package { 'mcollective-puppet-agent':
    ensure => installed,
  }

}
