# == Class: dc_nrpe::checks::disk_stats
#
class dc_nrpe::checks::disk_stats (
  $hdd_warnps_params,
  $hdd_critps_params,
  $hdd_queue_params,
  $hdd_wait_params,
  $ssd_warnps_params,
  $ssd_critps_params,
  $ssd_queue_params,
  $ssd_wait_params,
){

  dc_nrpe::check { 'check_disk_stats':
    path    => '/usr/local/bin/check_disk_stats.sh',
    content => template('dc_nrpe/check_disk_stats.sh.erb'),
    sudo    =>  true
  }

}
