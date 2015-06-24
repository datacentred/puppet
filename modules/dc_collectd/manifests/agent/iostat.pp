# == Class: dc_collectd::agent::iostat
class dc_collectd::agent::iostat {

  # Install pre-reqs
  ensure_packages('sysstat')

  File {
    owner => 'root',
    group => 'root',
  }

  # Make plugins directory structure
  file { '/usr/lib/collectd/python':
    ensure  => directory,
    mode    => '0755',
    require => Package['collectd'],
  } ->

  # Copy in new plugin
  file { '/usr/lib/collectd/python/collectd_iostat_python.py':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/dc_collectd/collectd_iostat_python.py',
  } ->

  # Add config
  file { '/etc/collectd/conf.d/10-iostat.conf':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/dc_collectd/10-iostat.conf',
    notify  => Service['collectd'],
  }

}
