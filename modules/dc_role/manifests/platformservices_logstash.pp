# Class: dc_role::platformservices_logstash
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
class dc_role::platformservices_logstash {

  contain dc_profile::kibana
  contain dc_profile::logstash
  contain dc_profile::logstashbackup

}
