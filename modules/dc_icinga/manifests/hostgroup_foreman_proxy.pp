# == Class: dc_icinga::hostgroup_foreman_proxy
#
class dc_icinga::hostgroup_foreman_proxy {
  external_facts::fact { 'dc_hostgroup_foreman_proxy': }
}
