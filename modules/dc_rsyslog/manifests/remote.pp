# Class: dc_rsyslog::remote
#
# Sets up remote syslogging
#
class dc_rsyslog::remote {

  file { '/etc/rsyslog.d/60-remote.conf':
    path   => '/etc/rsyslog.d/60-remote.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_rsyslog/60-remote.conf',
    notify => Class['dc_rsyslog::service'],
  }

}
