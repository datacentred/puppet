# == Class: llama::configure
#
# Configures the llama service
#
class llama::configure {

  assert_private()

  $_llama_basedir = $::llama::llama_basedir
  $_llama_collector_confdir = $::llama::llama_collector_confdir
  $_llama_is_reflector = $::llama::llama_is_reflector
  $_llama_reflector_bindport = $::llama::llama_reflector_bindport
  $_llama_reflector_loglevel = $::llama::llama_reflector_loglevel
  $_llama_reflector_logfile = $::llama::llama_reflector_logfile
  $_llama_is_collector = $::llama::llama_is_collector
  $_llama_collector_loglevel = $::llama::llama_collector_loglevel
  $_llama_collector_logfile = $::llama::llama_collector_logfile
  $_llama_collector_count = $::llama::llama_collector_count
  $_llama_collector_interval = $::llama::llama_collector_interval
  $_llama_collector_http_bindip = $::llama::llama_collector_http_bindip
  $_llama_collector_http_bindport = $::llama::llama_collector_http_bindport
  $_llama_collector_use_udp = $::llama::llama_collector_use_udp
  $_llama_collector_config = $::llama::llama_collector_config

  exec { 'llama-build':
    command => "python ${_llama_basedir}/setup.py build",
    cwd     => $_llama_basedir,
    creates => "${_llama_basedir}/build",
  } ->

  exec { 'llama-install':
    command => "python ${_llama_basedir}/setup.py install",
    cwd     => $_llama_basedir,
    creates => '/usr/local/bin/llama_collector',
  }

  if $_llama_is_reflector {

    Exec['llama-install'] ->

    file { '/lib/systemd/system/llama_reflector.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('llama/llama_reflector.service.erb'),
    }
  }

  if $_llama_is_collector {

    Exec['llama-install'] ->

    file { $_llama_collector_confdir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    } ->

    file { "${_llama_collector_confdir}/llama_collector.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('llama/llama_collector.conf.erb'),
    } ->

    file { '/lib/systemd/system/llama_collector.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('llama/llama_collector.service.erb'),
    }
  }
}
