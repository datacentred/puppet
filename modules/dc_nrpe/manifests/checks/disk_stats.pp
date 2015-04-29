# == Class: dc_nrpe::checks::disk_stats
#
class dc_nrpe::checks::disk_stats {

  dc_nrpe::check { 'check_disk_stats':
    path   => '/usr/local/bin/check_disk_stats.sh',
    source => 'puppet:///modules/dc_nrpe/check_disk_stats',
    sudo   =>  true
  }

}
