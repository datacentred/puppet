# Class: dc_bmc::modules
#
# It ensures that ipmi modules are loaded
#
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_bmc::modules {

  include stdlib

  exec { 'module_refresh':
    command     => '/usr/sbin/service kmod restart',
    refreshonly => true,
  }

  file_line { 'ipmi_msghandler':
    line   => 'ipmi_msghandler',
    path   => '/etc/modules',
    notify => Exec['module_refresh'],
  }

  file_line { 'ipmi_devintf':
    line   => 'ipmi_devintf',
    path   => '/etc/modules',
    notify => Exec['module_refresh'],
  }

  file_line { 'ipmi_si':
    line   => 'ipmi_si',
    path   => '/etc/modules',
    notify => Exec['module_refresh'],
  }

}
