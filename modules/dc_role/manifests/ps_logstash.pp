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
class dc_role::ps_logstash {

  contain dc_profile::log::logstash
  contain dc_profile::log::kibana
  include ::dc_ssl::logstash
  contain dc_profile::log::riemann
  contain dc_profile::log::logstash_lbmember
}
