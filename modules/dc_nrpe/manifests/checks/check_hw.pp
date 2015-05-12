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
class dc_nrpe::checks::check_hw (
  $ceph_cpu = 16,
  $ceph_mem = 32,
  $nova_cpu = 16,
  $nova_mem = 65,
) {

  dc_nrpe::check { 'check_cephosd_hw':
    path   => '/usr/local/bin/check_hw.sh',
    args   => "-c ${ceph_cpu} -m ${ceph_mem}",
    source => 'puppet:///modules/dc_nrpe/check_hw.sh',
    sudo   => true,
  }

  dc_nrpe::check { 'check_compute_hw':
    path => '/usr/local/bin/check_hw.sh',
    args => "-c ${nova_cpu} -m ${nova_mem}",
    sudo => true,
  }

}
