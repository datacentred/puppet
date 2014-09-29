# == Class: dc_icinga::hostgroup_mysql
#
class dc_icinga::hostgroup_mysql {
  external_facts::fact { 'dc_hostgroup_mysql': }
}
