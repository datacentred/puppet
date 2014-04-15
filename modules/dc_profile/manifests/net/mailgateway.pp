# Class: dc_profile::net::mailgateway
#
# Installs postfix as a mail gateway
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::net::mailgateway {

  include dc_postfix

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_smtp']
  realize Dc_external_facts::Fact['dc_hostgroup_postfix']

}
