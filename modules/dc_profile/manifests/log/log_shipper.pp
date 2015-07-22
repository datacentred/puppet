# Class: dc_profile::log::log_shipper
#
# Installs a log shipper to monitor files
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
class dc_profile::log::log_shipper {

  include ::dc_logstash::client

}
