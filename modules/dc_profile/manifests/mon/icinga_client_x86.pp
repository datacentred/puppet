# == Class: dc_profile::mon::icinga_client_x86
#
# x86 specific icinga configuration. For when the check is a binary and not
# a script
#
class dc_profile::mon::icinga_client_x86 {

  include ::dc_icinga::hostgroup_x86

}
