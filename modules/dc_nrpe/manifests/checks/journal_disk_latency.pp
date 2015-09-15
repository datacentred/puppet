# == Class: dc_nrpe::checks::journal_disk_latency
#
class dc_nrpe::checks::journal_disk_latency (
  $write_latency_warn = 250,
  $write_latency_crit = 500,
  $journal_disk = 'sdg',
  $hist_stats_file = '/tmp/journal_disk_writes.pkl',
){

  validate_integer($write_latency_warn)
  validate_integer($write_latency_crit)

  $config = {
    'hist_stats_file'      => $hist_stats_file,
    'journal_disk'         => $journal_disk,
    'journal_disk_latency' => {
      'warn' => $write_latency_warn,
      'crit' => $write_latency_crit,
    },
  }

  file { '/usr/local/etc/check_journal_disk.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => inline_template('<%= YAML.dump(@config) %>')
  }

  dc_nrpe::check { 'check_journal_disk_latency':
    path   => '/usr/local/bin/check_journal_disk_latency.py',
    source => 'puppet:///modules/dc_nrpe/check_journal_disk_latency.py',
  }

}
