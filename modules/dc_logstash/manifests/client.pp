# == Class: dc_logstash::client
#
# Installs a logshipper and scans for a standard set of logs
#
# === Parameters
#
class dc_logstash::client {

  include ::filebeat

}
