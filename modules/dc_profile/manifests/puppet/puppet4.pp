# == Class: dc_profile::puppet::puppet4
#
# Puppet 4 specific operations
#
class dc_profile::puppet::puppet4 {

  include ::stdlib::stages

  class { 'dc_profile::puppet::puppet4_setup':
    stage => 'setup',
  }

  if ! $::role in ['puppet_ca', 'puppet_master'] {
    if $::domain =~ /^.*example.com$/ {
      $_config = @("EOF")
        [agent]
        server = puppet.example.com
        | EOF
    } else {
      $_config = @("EOF")
        [agent]
        server = puppet.datacentred.services
        | EOF
    }

    file { '/etc/puppetlabs/puppet/puppet.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $_config,
    }
  }

  cron { 'puppet-agent':
    command => '/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize',
    user    => 'root',
    minute  => interval_to_minute(30),
  }

}
