# == Define: dc_logstash::client::register
#
define dc_logstash::client::register ($logs, $fields, $order='10') {

  validate_hash($fields)

  $default_fields = {
    'shipper'   => 'logstash-forwarder' }

  $merged_fields = merge($default_fields, $fields)

  $json_fields = sorted_json($merged_fields)

  concat::fragment { "logstash_forwarder_log_${name}":
    target  => '/etc/logstash-forwarder',
    order   => $order,
    content => template('dc_logstash/logstash-forwarder_client_log.erb'),
  }

  concat::fragment { "log-courier_log_${name}":
    target  => '/etc/log-courier.conf',
    order   => $order,
    content => template('dc_logstash/log-courier_client_log.erb'),
  }
}
