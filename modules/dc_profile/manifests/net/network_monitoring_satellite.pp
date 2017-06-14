# Class: dc_profile::net::network_monitoring_satellite
#
# Deploys a Zabbix 3 proxy and agent.
#
class dc_profile::net::network_monitoring_satellite {

    include ::dc_zabbix::proxy

    file { '/var/log/network':
      ensure => directory,
      owner  => 'syslog',
      group  => 'adm',
      mode   => '0755',
    }

    logrotate::rule { 'network_monitoring_satellite':
      path          => '/var/log/network/*/*.log',
      rotate        => 6,
      rotate_every  => 'day',
      ifempty       => false,
      delaycompress => true,
      compress      => true,
    }

}
