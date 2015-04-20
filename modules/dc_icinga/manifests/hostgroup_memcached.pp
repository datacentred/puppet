# == Class: dc_icinga::hostgroup_memcached
#
class dc_icinga::hostgroup_memcached {
  external_facts::fact { 'dc_hostgroup_memcached': }
}
