define dc_logstash::client::register ($logs, $order='10', $fields) {

  validate_hash($fields)

  $json_type = sorted_json($fields)

  concat::fragment { "logstash_forwarder_log_$name":
    target  => '/etc/logstash-forwarder',
    order   => $order,
    content => template('dc_logstash/logstash-forwarder_client_log.erb'),
  }
}
