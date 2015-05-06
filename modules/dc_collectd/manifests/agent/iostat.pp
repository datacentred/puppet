# == Class: dc_collectd::agent::iostat
class dc_collectd::agent::iostat {

  # Install pre-reqs
  ensure_packages('sysstat')

  # Make plugins directory structure
  file { 'usr/lib/collectd/python':
    ensure  => directory,
    require => Package['collectd'],
  }

  # Copy in new plugin
  file { '/usr/lib/collectd/python/collectd_iostat_python.py':
    ensure  => file,
    require => File[$pythondirs],
    source  => 'puppet:///modules/dc_collectd/collectd_iostat_python.py',
  }

  # Add config
  file { '/etc/collectd/conf.d/10-iostat.conf':
    ensure  => file,
    source  => 'puppet:///modules/dc_collectd/10-iostat.conf',
    require => File['/usr/lib/collectd/python/collectd_iostat_python.py'],
    notify  => Service['collectd'],
  }

}
