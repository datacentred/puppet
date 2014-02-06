# Class: dc_gdash
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class dc_gdash (
  $gdash_root = undef,
  $graphite_server = hiera(graphite_server),
  $whisper_root = '/var/opt/graphite/storage/whisper',
) {
  file { $gdash_root:
    ensure  => directory,
    recurse => true,
  }

  package { ['ruby-dev', 'git', 'ruby-bundler', 'rubygems', 'libapache2-mod-passenger' ]:
    ensure => present,
  }

  vcsrepo { 'gdash_github':
    ensure   => present,
    path     => $gdash_root,
    provider => 'git',
    source   => 'https://github.com/ripienaar/gdash.git',
    require  => Package['git'],
  }
    
  bundler::install { $gdash_root:
    user       => root,
    group      => root,
    deployment => true,
    require    => [ Package['git'], Vcsrepo['gdash_github'] ],
  }

  file { "/etc/apache2/sites-available/gdash.conf":
    owner   => root,
    group   => www-data,
    content => template('dc_gdash/gdash.conf.erb'),
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

  file { "/etc/apache2/sites-enabled/20-gdash.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/gdash.conf",
    notify  => Service['apache2'],
    require => File["/etc/apache2/sites-available/gdash.conf"]
  }

  exec { 'enable-headers':
    command => '/usr/sbin/a2enmod headers',
    creates => '/etc/apache2/mods-enables/headers.load',
    notify  => Service['apache2'],
  }

  file { "/var/www/gdash/config/gdash.yaml":
    owner   => root,
    group   => www-data,
    content => template('dc_gdash/gdash.yaml.erb'),
    require => Vcsrepo['gdash_github'],
  }



}
