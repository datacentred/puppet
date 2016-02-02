# Class: dc_bmc::housekeeper
#
# Add some housekeeping cron stuff
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
class dc_bmc::housekeeper {

  file { '/usr/local/bin/bmc_housekeeper.sh':
    ensure => file,
    source => 'puppet:///modules/dc_bmc/bmc_housekeeper.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  cron { 'bmc_housekeeper':
    ensure  => present,
    command => '/usr/local/bin/bmc_housekeeper.sh',
    weekday => 0,
    hour    => 2,
    minute  => 0,
  }

}
