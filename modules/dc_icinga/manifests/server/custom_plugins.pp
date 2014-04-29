class dc_icinga::server::custom_plugins {

  # Custom nagios plugins

  file { '/usr/lib/nagios/plugins':
    ensure  => directory,
    source  => 'puppet:///modules/dc_icinga/custom_plugins',
    owner   => 'root',
    group   => 'root',
    purge   => false,
    recurse => 'remote',
  }

}
