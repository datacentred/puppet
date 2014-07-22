class dc_rsyslog::config {

  file { '/etc/rsyslog.d':
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
  }

  file { '/etc/rsyslog.d/50-default.conf':
    path   => '/etc/rsyslog.d/50-default.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_rsyslog/50-default.conf',
    notify => Service['rsyslog'],
  }

  file { '/etc/rsyslog.d/20-ufw.conf':
    path   => '/etc/rsyslog.d/20-ufw.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dc_rsyslog/20-ufw.conf',
    notify => Service['rsyslog'],
  }
}
