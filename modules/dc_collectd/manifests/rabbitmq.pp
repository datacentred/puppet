class dc_collectd::rabbitmq {

  # Add new rabbit type to types.db
  file_line { '/usr/share/collectd/types.db':
    line    => 'rabbitmq                messages:GAUGE:0:U, messages_rate:GAUGE:0:U, messages_unacknolwedged:GAUGE:0:U, messages_unacknowledged_rate:GAUGE:0:U, messages_ready:GAUGE:0:U, message_ready_rate:GAUGE:0:U, memory:GAUGE:0:U, consumers:GAUGE:0:U, publish:GAUGE:0:U, publish_rate:GAUGE:0:U, deliver_no_ack:GAUGE:0:U, deliver_no_ack_rate:GAUGE:0:U, deliver_get:GAUGE:0:U, deliver_get_rate:GAUGE:0:U',
    require => Class[Dc_collectd],
  }

  # Copy in new plugin
  file { '/usr/lib/collectd/rabbitmq.pm':
    ensure => file,
    source => 'puppet:///modules/dc_collectd/RabbitMQ.pm',
  }

}
