# == Class: dc_profile::puppet::puppet4
#
# Puppet 4 specific operations
#
class dc_profile::puppet::puppet4 {

  include ::stdlib::stages

  class { 'dc_profile::puppet::puppet4_setup':
    stage => 'setup',
  }

  if $::role in ['puppet_ca', 'puppet_master'] {
    $_config = @("EOF")
      [agent]
      server = puppet.datacentred.services

      [master]
      vardir = /opt/puppetlabs/server/data/puppetserver
      logdir = /var/log/puppetlabs/puppetserver
      rundir = /var/run/puppetlabs/puppetserver
      pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
      codedir = /etc/puppetlabs/code
      storeconfigs = true
      storeconfigs_backend = puppetdb
      node_terminus = exec
      external_nodes = /etc/puppetlabs/puppet/node.rb
      reports = foreman
      | EOF
  } elsif $::domain =~ /^*.example.com$/ {
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

  cron { 'puppet-agent':
    command => '/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize',
    user    => 'root',
    minute  => interval_to_minute(30),
  }

}
