# == Class: dc_icinga::hostgroup_logstashes
#
class dc_icinga::hostgroup_logstashes {
  external_facts::fact { 'dc_hostgroup_logstashes': }
}
