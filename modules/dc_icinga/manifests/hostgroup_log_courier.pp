# == Class: dc_icinga::hostgroup_log_courier
#
class dc_icinga::hostgroup_log_courier {
  external_facts::fact { 'dc_hostgroup_log_courier': }
}
