# Class: dc_role::logstash
#
# Logstash and elastic search server
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_role::logstash {

  contain dc_profile::log::kibana
  contain dc_profile::log::logstash
  contain dc_profile::log::logstashbackup
  contain dc_profile::log::riemann

}
