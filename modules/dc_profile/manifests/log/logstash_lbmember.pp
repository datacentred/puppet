# Class: dc_profile::log::logstash_lbmember
#
# Gives stats from loadbalancer members to haproxy for cluster management
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::logstash_lbmember {

  include ::loadbalancer::members

}
