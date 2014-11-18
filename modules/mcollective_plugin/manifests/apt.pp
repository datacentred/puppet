# == Class: mcollective_plugin::apt
#
class mcollective_plugin::apt {

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['mcollective'],
  }

  file { '/usr/share/mcollective/plugins/mcollective/agent/apt.ddl':
    source => 'puppet:///modules/mcollective_plugin/apt.ddl',
  }

  file { '/usr/share/mcollective/plugins/mcollective/agent/apt.rb':
    source => 'puppet:///modules/mcollective_plugin/apt.rb',
  }

}
