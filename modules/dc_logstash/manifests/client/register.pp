define dc_logstash::client::register ($logs, $fields, $order='10') {

  validate_hash($fields)

  $json_fields = sorted_json($fields)

  concat::fragment { "logstash_forwarder_log_${name}":
    target  => '/etc/logstash-forwarder',
    order   => $order,
    content => template('dc_logstash/logstash-forwarder_client_log.erb'),
  }
}
