# == Class: dc_profile::cstates
#
# Disables C-states in the kernel
#
class dc_profile::hardware::cstates {

  kernel_parameter { 'intel_idle.max_cstate':
    ensure => present,
    value  => '0',
  }

}
