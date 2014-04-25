# Class: dc_logstash
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
class dc_logstash {

  # Basic class for installing Logstash
  class { '::logstash': }

  # On precise upstart doesn't respect supplementary groups
  # so we have to hack the upstart config to force execution
  # as puppet to allow access to the SSL certs.  This has
  # alledgedly been fixed upstream, so just use UNIX standards
  if $::lsbdistcodename == 'precise' {
    exec { 'logstash patch upstart':
      command => '/bin/sed -ie "s/setgid logstash/setgid puppet/" /etc/init/logstash.conf',
      onlyif  => '/bin/grep "setgid logstash" /etc/init/logstash.conf',
      require => Package['logstash'],
      notify  => Service['logstash'],
    }
  } else {
    exec { '/usr/sbin/usermod -a -G puppet logstash':
      unless  => '/usr/bin/groups logstash | /bin/grep puppet',
      require => [ Package['logstash'], Package['puppet'] ],
    }
  }

  # Add directory and install patterns for filters and parsers
  $logstash_grok_patterns_dir = hiera(logstash_grok_patterns_dir)

  file { $logstash_grok_patterns_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    source  => 'puppet:///modules/dc_logstash/grok',
    require => Class['::logstash'],
  }

  # the package for logstash-contrib has broken dependencies currently
  # so hacky manual method for now
  exec { 'install-contrib':
    creates => '/opt/logstash/lib/logstash/outputs/riemann.rb',
    cwd     => '/opt/logstash',
    command => '/opt/logstash/bin/plugin install contrib',
    require => Class['::logstash'],
  }

  # Add config files

  class { 'dc_logstash::config::input_syslog':}
  class { 'dc_logstash::config::input_forwarder':}
  class { 'dc_logstash::config::output_elasticsearch':}
  class { 'dc_logstash::config::output_riemann':}
  class { 'dc_logstash::config::output_riemann_dev':}
  class { 'dc_logstash::config::filter_grok_apache':}
  class { 'dc_logstash::config::filter_grok_apache_err':}
  class { 'dc_logstash::config::filter_grok_mysql_err':}

  # Add icinga config
  class { 'dc_logstash::icinga': }

}
