# == Class: dc_bmc::debian::modules
#
# Ensures that ipmi modules are loaded
#
class dc_bmc::debian::modules {

  File_line {
    notify => Exec['module_refresh'],
    path   => '/etc/modules',
  }

  file_line { 'ipmi_msghandler':
    line   => 'ipmi_msghandler',
  }

  file_line { 'ipmi_devintf':
    line   => 'ipmi_devintf',
  }

  file_line { 'ipmi_si':
    line   => 'ipmi_si',
  }

  exec { 'module_refresh':
    command     => '/usr/sbin/service kmod restart',
    refreshonly => true,
  }

}
