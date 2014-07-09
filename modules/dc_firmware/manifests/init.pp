# Class: dc_firmware
#
# Module to load software and data needed for flashing firmware and BIOS
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
class dc_firmware {

  include stdlib

  case $::virtual {

    physical: {

      case $::lsbdistcodename {
        'precise': {
          $module_service = 'module-init-tools'
        }
        default: {
          $module_service = 'kmod'
        }
      }

      File {
        owner => 'root',
        group => 'root',
      }

      package { 'flashrom':
        ensure => installed,
      }

      package { 'nvramtool':
        ensure => installed,
      }

      package { 'libc6-i386':
        ensure => installed,
      }

      package { 'ipmitool':
        ensure => installed,
      }

      file { '/usr/local/bin/Yafuflash':
        ensure => file,
        source => 'puppet:///modules/dc_firmware/Yafuflash',
        mode   => '0744',
      }

      file { '/usr/local/bin/fwupdate.sh':
        ensure => file,
        source => 'puppet:///modules/dc_firmware/fwupdate.sh',
        mode   => '0744',
      }

      file { '/usr/local/lib/ipmi':
        ensure  => directory,
        source  => 'puppet:///modules/dc_firmware/ipmi',
        recurse => true,
      }

      file { '/usr/local/lib/firmware':
        ensure  => directory,
        source  => 'puppet:///modules/dc_firmware/firmware',
        recurse => true,
      }

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

    default: {}

  }
}
