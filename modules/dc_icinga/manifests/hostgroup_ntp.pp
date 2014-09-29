# == Class: dc_icinga::hostgroup_ntp
#
class dc_icinga::hostgroup_ntp {
  external_facts::fact { 'dc_hostgroup_ntp': }
}
