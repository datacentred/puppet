# == Class: dc_icinga::hostgroup_postgres
#
class dc_icinga::hostgroup_postgres {
  external_facts::fact { 'dc_hostgroup_postgres': }
}
