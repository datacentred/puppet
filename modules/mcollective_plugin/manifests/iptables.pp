# == Class: mcollective_plugin::iptables
#
class mcollective_plugin::iptables {

  package { 'mcollective-iptables-agent':
    ensure => installed,
  }

}
