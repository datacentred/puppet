# == Class: dc_icinga::hostgroup_supermicro_x9
#
# Flag the hardware is X9 class or greater
#
class dc_icinga::hostgroup_supermicro_x9 {
  external_facts::fact { 'dc_hostgroup_supermicro_x9': }
}
