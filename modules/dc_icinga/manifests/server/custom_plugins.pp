class dc_icinga::server::custom_plugins {

  # RabbitMQ plugins need libnagios-plugin-perl
  package { 'libnagios-plugin-perl':
    ensure => latest,
  }

  # Custom nagios plugins directory
  file { '/usr/lib/nagios/plugins':
    ensure  => directory,
    source  => 'puppet:///modules/dc_icinga/custom_plugins',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => false,
    recurse => 'remote',
  }

}
