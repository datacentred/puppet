# == Class: dc_rsyslog::config
#
class dc_rsyslog::config {

  file { '/etc/rsyslog.d':
    ensure  => directory,
    purge   => true,
    force   => true,
    recurse => true,
  }

  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/rsyslog.d/10-udp.conf':
    source => 'puppet:///modules/dc_rsyslog/10-udp.conf',
  }

  file { '/etc/rsyslog.d/50-default.conf':
    source => 'puppet:///modules/dc_rsyslog/50-default.conf',
  }

  file { '/etc/rsyslog.d/20-ufw.conf':
    source => 'puppet:///modules/dc_rsyslog/20-ufw.conf',
  }

}
