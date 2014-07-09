# Class: dc_firmware::modules
#
# Load the required modules for IPMI
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]i
class dc_firmware::modules {

  case $::lsbdistcodename {
    'precise': {
      $module_service = 'module-init-tools'
    }
    default: {
      $module_service = 'kmod'
    }
  }

  include stdlib

  exec { 'module_refresh':
    command     => "/usr/sbin/service ${module_service} restart",
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
