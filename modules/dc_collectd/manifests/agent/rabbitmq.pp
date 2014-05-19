class dc_collectd::agent::rabbitmq (
  $rabbitmq_monuser = hiera(rabbitmq_monuser),
  $rabbitmq_monuser_password = hiera(rabbitmq_monuser_password),
  $realm = 'RabbitMQ Management',
  $port = '15672',
  $rabbithost = 'localhost',
){

  # Add new rabbit type to types.db
  file_line { '/usr/share/collectd/types.db':
    line    => 'rabbitmq                messages:GAUGE:0:U, messages_rate:GAUGE:0:U, messages_unacknolwedged:GAUGE:0:U, messages_unacknowledged_rate:GAUGE:0:U, messages_ready:GAUGE:0:U, message_ready_rate:GAUGE:0:U, memory:GAUGE:0:U, consumers:GAUGE:0:U, publish:GAUGE:0:U, publish_rate:GAUGE:0:U, deliver_no_ack:GAUGE:0:U, deliver_no_ack_rate:GAUGE:0:U, deliver_get:GAUGE:0:U, deliver_get_rate:GAUGE:0:U',
    require => Class[Dc_collectd],
  }

  # Install pre-reqs
  $prereqs = [ 'libwww-perl', 'libjson-perl' ]
  package { $prereqs :
    ensure => present,
  }

  # Make plugins directory structure
  $perldirs = [ '/usr/lib/collectd/perl', '/usr/lib/collectd/perl/Collectd', '/usr/lib/collectd/perl/Collectd/Plugins' ]
  file { $perldirs:
    ensure => directory,
  }

  # Copy in new plugin
  file { '/usr/lib/collectd/perl/Collectd/Plugins/RabbitMQ.pm':
    ensure  => file,
    require => File[$perldirs],
    source  => 'puppet:///modules/dc_collectd/RabbitMQ.pm',
  }

  # Add config
  file { '/etc/collectd/conf.d/10-rabbitmq.conf':
    ensure  => file,
    content => template(dc_collectd/10-rabbitmq.conf.erb),
  }

}
