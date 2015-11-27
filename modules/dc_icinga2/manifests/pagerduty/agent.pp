# == Class: dc_icinga2::pagerduty::agent
#
# Install the scripts and dependencies for a node to alert
#
class dc_icinga2::pagerduty::agent {

  ensure_packages($::dc_icinga2::pagerduty_deps)

  file { '/usr/local/bin/pagerduty_icinga.pl':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_icinga2/pagerduty_icinga.pl',
  }

}
