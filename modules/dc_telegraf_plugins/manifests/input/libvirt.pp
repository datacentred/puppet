# Class: dc_telegraf_plugins::input::libvirt
#
# Sets up libvirt monitoring via telegraf 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_telegraf_plugins::input::libvirt {

  ensure_packages('python-libvirt')

  file {'/usr/local/bin/libvirt_telegraf.py':
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/dc_telegraf_plugins/input/libvirt_telegraf.py',
  }

}

