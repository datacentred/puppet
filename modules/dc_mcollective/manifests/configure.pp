# == Class: dc_mcollective::configure
#
class dc_mcollective::configure {

  # Copy in unpackaged plugins
  file { '/usr/share/mcollective/plugins/mcollective/agent':
    ensure  => directory,
    source  => 'puppet:///modules/dc_mcollective/agent',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => false,
    recurse => 'remote',
    # Ugh, knowing about other module internals
    notify  => Service['mcollective'],
  }

  mcollective::server::setting { 'registration':
    value => 'agentlist',
  }

  mcollective::server::setting { 'registerinterval':
    value => 900,
  }

}
