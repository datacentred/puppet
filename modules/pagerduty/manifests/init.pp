# == Class: pagerduty
#
class pagerduty {

  package { 'pdagent':
    ensure => installed,
  } ->

  package { 'pdagent-integrations':
    ensure => installed,
  } ->

  service { 'pdagent':
    ensure => running,
    enable => true,
  }

}

