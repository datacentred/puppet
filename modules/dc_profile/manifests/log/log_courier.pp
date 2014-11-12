# Class: dc_profile::log::log_courier
#
# Installs the logstash forwarder to monitor files
# and pipe the output to the server.  This is a
# compressed and secure pipe
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::log_courier {

  contain dc_logstash::client
  contain dc_logstash::client::forwarder
  contain dc_logstash::client::apache
  contain dc_logstash::client::mysql
  contain dc_logstash::client::mail
  contain dc_logstash::client::syslog

}
