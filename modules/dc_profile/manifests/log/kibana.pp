# Class: dc_profile::log::kibana
#
# Installs the logstash GUI
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::log::kibana {

  include apache

  class {'dc_kibana':
    elasticsearch_host => hiera(logstash_server)
  }

}
