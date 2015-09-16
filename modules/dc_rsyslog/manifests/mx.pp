# Class: dc_rsyslog::mx
#
# Exclude haproxy logging on mx
#
class dc_rsyslog::mx {

  file { '/etc/rsyslog.d/30-mx.conf':
    path   => '/etc/rsyslog.d/30-mx.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_rsyslog/30-mx.conf',
    notify => Class['dc_rsyslog::service'],
  }

}
