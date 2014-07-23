# Class: dc_nrpe::logstash
#
# Logstash specific nrpe configuration
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
class dc_nrpe::logstash {

  $logstash_forwarder_port = hiera(logstash_forwarder_port)

  if defined(Class['::dc_logstash::client::forwarder']) {

    sudo::conf { 'check_logstash_forwarder_netstat':
      priority => 10,
      content  => 'nagios ALL=NOPASSWD:/usr/lib/nagios/plugins/check_logstash-forwarder.sh',
    }

    file { '/etc/nagios/nrpe.d/logstash_forwarder_netstat.cfg':
      ensure  => present,
      content => 'command[check_logstash_forwarder_netstat]=/usr/lib/nagios/plugins/check_logstash-forwarder.sh',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }

    file { '/usr/lib/nagios/plugins/check_logstash-forwarder.sh':
      ensure  => file,
      content => template('dc_nrpe/check_logstash-forwarder.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['nagios-nrpe-server'],
      notify  => Service['nagios-nrpe-server'],
    }
  }
}
