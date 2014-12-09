# == Class: dc_icinga::hostgroup_mongodb
#
class dc_icinga::hostgroup_mongodb {
  external_facts::fact { 'dc_hostgroup_mongodb': }
}
