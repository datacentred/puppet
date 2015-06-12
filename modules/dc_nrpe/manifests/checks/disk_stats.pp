# == Class: dc_nrpe::checks::disk_stats
#
class dc_nrpe::checks::disk_stats (
  $queue_depth_warn = 50,
  $queue_depth_crit = 100,
){

  validate_integer($queue_depth_warn)
  validate_integer($queue_depth_crit)

  $config = {
    'queue_depth' => {
      'warn' => $queue_depth_warn,
      'crit' => $queue_depth_crit,
    },
  }

  file { '/usr/local/etc/check_disk_stats.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => inline_template('<%= YAML.dump(@config) %>')
  }

  dc_nrpe::check { 'check_disk_stats.py':
    path   => '/usr/local/bin/check_disk_stats.py',
    source => 'puppet:///modules/dc_nrpe/check_disk_stats',
  }

}
