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
# [Remember: No empty lines between comments and class definition]
class dc_firmware {

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

}
