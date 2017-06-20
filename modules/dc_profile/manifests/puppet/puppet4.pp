# == Class: dc_profile::puppet::puppet4
#
# Puppet 4 specific operations
#
class dc_profile::puppet::puppet4 {

  include ::puppet
  include ::stdlib::stages

  class { 'dc_profile::puppet::puppet4_setup':
    stage => 'setup',
  }

  cron { 'puppet-agent':
    ensure => absent,
  }
}
