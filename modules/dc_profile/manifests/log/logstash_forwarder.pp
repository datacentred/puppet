# Class: dc_profile::log::logstash_forwarder
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
class dc_profile::log::logstash_forwarder {

  contain dc_logstash::forwarder

}
