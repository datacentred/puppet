# Class: dc_profile::util::fail2ban
#
# Installs/configures fail2ban
#
#
class dc_profile::util::fail2ban {

  include ::fail2ban

  logrotate::rule { 'fail2ban':
    path          => '/var/log/fail2ban.log',
    rotate        => 4,
    rotate_every  => 'week',
    compress      => true,
    delaycompress => true,
    create_owner  => 'syslog',
    create_group  => 'adm',
    create_mode   => '640',
    create        => true,
    missingok     => true,
    postrotate    => 'fail2ban-client flushlogs 1>/dev/null',
  }
}
