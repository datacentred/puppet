# == Class: dc_logstash::client
#
# Installs a logshipper and scans for a standard set of logs
#
# === Parameters
#
class dc_logstash::client (
  $config,
) {

  include ::dc_logstash::client::install
  include ::dc_logstash::client::configure
  include ::dc_logstash::client::service

  Class['::dc_logstash::client::install'] ->
  Class['::dc_logstash::client::configure'] ~>
  Class['::dc_logstash::client::service']

}
