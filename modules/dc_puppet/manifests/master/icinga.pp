#
class dc_puppet::master::icinga {

  include dc_icinga::hostgroups
  realize Dc_external_facts::Fact['dc_hostgroup_puppetmaster']
  realize Dc_external_facts::Fact['dc_hostgroup_foreman_proxy']

}
