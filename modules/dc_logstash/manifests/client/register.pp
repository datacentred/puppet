# == Define: dc_logstash::client::register
#
# codec_hash supports multiple codecs, and should be a hash of hashes
#
define dc_logstash::client::register ( $logs, $fields, $order='10', $codec_hash=undef ) {

  validate_hash($fields)

  if $codec_hash {
    validate_hash($codec_hash)
  }

  if $::architecture == 'aarch64' {
    concat::fragment { "beaver_log_${name}":
      target  => '/etc/beaver/beaver.conf',
      order   => $order,
      content => template('dc_logstash/client/beaver_client_log.erb'),
    }
  }

}
