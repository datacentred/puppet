# == Class: dc_icinga::hostgroup_puppetmaster
#
class dc_icinga::hostgroup_puppetmaster {
  external_facts::fact { 'dc_hostgroup_puppetmaster': }
}
