# == Class: dc_icinga::hostgroup_rabbitmq
#
class dc_icinga::hostgroup_rabbitmq {
  external_facts::fact { 'dc_hostgroup_rabbitmq': }
}
