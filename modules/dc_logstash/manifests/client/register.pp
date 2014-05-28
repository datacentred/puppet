define dc_logstash::client::register ($logs, $order='10', $type) {
  concat::fragment { "logstash_forwarder_log_$name":
    target  => '/etc/logstash-forwarder',
    order   => $order,
    content => template('dc_logstash/logstash-forwarder_client_log.erb'),
  }
}
