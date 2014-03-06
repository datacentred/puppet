# Class: dc_profile::log::rsyslog_remote
#
# Configures rsyslog to allow remote connections
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::rsyslog_remote {

  class { 'dc_rsyslog::remote': }

}
