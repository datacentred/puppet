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

  # Don't use the check class as we've got two checks using the same file
  file { '/usr/local/bin/check_hw.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dc_nrpe/check_hw.sh'
  }

  file { '/usr/local/bin/check_hw_compute.sh':
    ensure => absent,
  }

  file { '/usr/local/bin/check_hw_osd.sh':
    ensure => absent,
  }

  concat::fragment { 'check_cephosd_hw':
    target  => '/etc/nagios/nrpe.d/dc_nrpe_check.cfg',
    content => 'command[check_cephosd_hw]=sudo /usr/local/bin/check_hw.sh -c 16 -m 32',
  }

  concat::fragment { 'check_compute_hw':
    target  => '/etc/nagios/nrpe.d/dc_nrpe_check.cfg',
    content => 'command[check_compute_hw]=sudo /usr/local/bin/check_hw.sh -c 16 -m 64',
  }

}
