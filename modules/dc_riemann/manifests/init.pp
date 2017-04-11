# Class: dc_riemann
#
# Install and configure riemann
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_riemann (
  $sysmail_address,
  $riemann_from_email_address,
  $riemann_config_dir,
  $riemann_whitelist,
  $riemann_pagerduty_key,
  $riemann_pagerduty_blacklist,
  $riemann_hipchat_auth_token,
  $riemann_hipchat_room,
  $riemann_hipchat_from,
  $riemann_slack_api_key,
  $riemann_slack_room,
  $riemann_slack_user,
  $riemann_slack_account
){

  class { 'riemann':
    # Specify the latest version, because the package default is old
    version     => '0.2.13',
    config_file => '/etc/riemann.config',
    require     => [ File['/etc/riemann.config'], Package['ruby-dev'] ],
  }

  class { 'riemann::dash':
    host    => $::ipaddress,
    require => Class['riemann'],
  }

  package { 'ruby-dev':
    ensure => 'installed',
  }

  file { '/etc/riemann.config':
    ensure  => file,
    content => template('dc_riemann/riemann.config.erb'),
  }

  file { '/etc/riemann.conf.d':
    ensure => directory,
    purge  => true,
    owner  => 'riemann',
    group  => 'riemann',
  }

  file { '/etc/riemann.conf.d/riemann.whitelist':
    ensure => file,
    owner  => 'riemann',
    group  => 'riemann',
    source => 'puppet:///modules/dc_riemann/riemann.whitelist',
    notify => Service['riemann'],
  }

  logrotate::rule { 'riemann':
    path         => '/var/log/riemann.log',
    rotate       => 7,
    rotate_every => 'day',
  }

  include dc_riemann::syslog_pagerduty_stream
  include dc_riemann::syslog_hipchat_stream
  include dc_riemann::syslog_email_stream
  include dc_riemann::syslog_slack_stream
  include dc_riemann::oslog_hipchat_stream
  include dc_riemann::oslog_email_stream
  include dc_riemann::oslog_slack_stream

}

