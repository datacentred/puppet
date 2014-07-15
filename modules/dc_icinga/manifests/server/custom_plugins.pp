class dc_icinga::server::custom_plugins {

  # RabbitMQ plugins need libnagios-plugin-perl
  package { 'libnagios-plugin-perl':
    ensure => latest,
  }

  # Python packages for Openstack checks
  package { 'python-keystoneclient':
    ensure => installed,
  }

  package { 'python-neutronclient':
    ensure => installed,
  }

  package { 'python-novaclient':
    ensure => installed,
  }

  package { 'python-cinderclient':
    ensure => installed,
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
    require => Class['::icinga::client'],
  }

}
