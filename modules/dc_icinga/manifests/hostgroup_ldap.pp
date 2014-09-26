# == Class: dc_icinga::hostgroup_ldap
#
class dc_icinga::hostgroup_ldap {
  external_facts::fact { 'dc_hostgroup_ldap': }
}
