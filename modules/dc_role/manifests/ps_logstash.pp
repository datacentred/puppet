# Class: dc_role::ps_logstash
#
# Role for setting up logstash to support platform services
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::ps_logstash inherits dc_role {

  contain dc_profile::log::logstash

}