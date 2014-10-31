# == Class: dc_icinga::hostgroup_elasticsearch
#
class dc_icinga::hostgroup_elasticsearch {
  external_facts::fact { 'dc_hostgroup_elasticsearch': }
}