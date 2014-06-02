# Class: dc_puppet::master::icinga
#
# Puppet master monitoring
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_puppet::master::icinga {

  include dc_icinga::hostgroup_puppetmaster
  include dc_icinga::hostgroup_foreman_proxy

}
