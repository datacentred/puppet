# == Class: dc_profile::puppet::puppet4
#
# Puppet 4 specific operations
#
class dc_profile::puppet::puppet4 {

  include ::stdlib::stages

  class { 'dc_profile::puppet::puppet4_setup':
    stage => 'setup',
  }

  cron { 'puppet-agent':
    command => '/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --server puppet4.incubator.datacentred.io',
    user    => 'root',
    minute  => interval_to_minute(30),
  }

}
