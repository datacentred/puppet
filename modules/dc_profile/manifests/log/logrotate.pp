# Class: dc_profile::log::logrotate
#
# Basic class for installing logrotate and subsequent configuration
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::logrotate {

  # Set the defaults
  logrotate::conf { '/etc/logrotate.conf':
    rotate       => 90,
    rotate_every => 'day',
    ifempty      => false,
    create       => true,
    su_group     => 'syslog',
    su_user      => 'root',
  }

  # Replacement for standard rsyslog rotation
  logrotate::rule { 'dc_rsyslog':
    path          => '/var/log/syslog',
    rotate        => 90,
    rotate_every  => 'day',
    ifempty       => false,
    delaycompress => true,
    compress      => true,
    postrotate    => 'invoke-rc.d rsyslog rotate > /dev/null',
  }

  # Replacement for other logrotate rules in default rsyslog rotation
  logrotate::rule { 'dc_othersyslog':
    path          => '/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/rsyslog.log
/var/log/debug
/var/log/haproxy.log
/var/log/messages',
    rotate        => 13,
    rotate_every  => 'week',
    missingok     => true,
    ifempty       => false,
    compress      => true,
    delaycompress => true,
    sharedscripts => true,
    postrotate    => 'invoke-rc.d rsyslog rotate > /dev/null',
  }

  # Remove installed logrotate config for above
  file { '/etc/logrotate.d/rsyslog':
    ensure  => absent,
    require => [Logrotate::Rule['dc_othersyslog'], Logrotate::Rule['dc_rsyslog']],
  }

}
