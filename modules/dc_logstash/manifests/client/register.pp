# == Define: dc_logstash::client::register
#
define dc_logstash::client::register ($logs, $fields, $order='10') {

  validate_hash($fields)

  $default_fields = {
    'shipper'   => 'log-courier' }

  $merged_fields = merge($default_fields, $fields)

  $json_fields = sorted_json($merged_fields)

  concat::fragment { "log_courier_log_${name}":
    target  => '/etc/log-courier/log-courier.conf',
    order   => $order,
    content => template('dc_logstash/client/log-courier_client_log.erb'),
  }
}
