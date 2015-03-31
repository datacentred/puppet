# Class: dc_nrpe::checks::check_hw
#
# Hardware specific nrpe configuration
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
class dc_nrpe::checks::check_hw {

  dc_nrpe::check { 'check_cephosd_hw':
    path   => '/usr/local/bin/check_hw.sh',
    args   => '-c 16 -m 32',
    source => 'puppet:///modules/dc_nrpe/check_hw.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_compute_hw':
    path => '/usr/local/bin/check_hw.sh',
    args => '-c 16 -m 65',
    sudo => true,
  }

}
