# == Class: dc_icinga::hostgroup_dhcp
#
class dc_icinga::hostgroup_dhcp {
  external_facts::fact { 'dc_hostgroup_dhcp': }
}
