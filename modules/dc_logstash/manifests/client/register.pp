# == Define: dc_logstash::client::register
#
# codec_hash supports multiple codecs, and should be a hash of hashes
#
define dc_logstash::client::register ($logs, $fields, $order='10', $codec_hash=undef ) {

  validate_hash($fields)

  if $codec_hash {
    validate_hash($codec_hash)
  }

  $default_fields = {
    'shipper'   => 'log-courier'
  }

  $merged_fields = merge($default_fields, $fields)

  $json_fields = sorted_json($merged_fields)

  concat::fragment { "log_courier_log_${name}":
    target  => '/etc/log-courier/log-courier.conf',
    order   => $order,
    content => template('dc_logstash/client/log-courier_client_log.erb'),
  }
}
