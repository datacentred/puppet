# Install json-based configuration file for native logstash
# updates
class dc_rsyslog::config {
  file { '/etc/rsyslog.d/30-jsonls.conf':
    ensure  => absent,
    path    => '/etc/rsyslog.d/30-jsonls.conf',
  }

  file { '/etc/rsyslog.d/50-default.conf':
    path    => '/etc/rsyslog.d/50-default.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dc_rsyslog/default.conf.erb'),
  }
}
