# == Class: dc_icinga::hostgroup_tftp
#
class dc_icinga::hostgroup_tftp {
  external_facts::fact { 'dc_hostgroup_tftp': }
}
