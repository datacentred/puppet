# Class: dc_profile::puppet::puppet
#
# Manages puppet agents on all nodes and provisions the master
# see dc_puppet for more details
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::puppet::puppet {

  # Annoyingly foreman installs puppet agent which starts up and causes
  # 4 runs an hour.  Inhibit this behaviour!
  service { 'puppet':
    ensure => stopped,
    enable => false,
  }

  contain ::puppet::agent::cron

}
