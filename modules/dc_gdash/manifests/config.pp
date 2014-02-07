class dc_gdash::config {

  # Additional considerations if we're not installing this 
  # on the Graphite server itself
  if $::fqdn != $dc_gdash::params::graphite_server {
    package { 'apache2':
      ensure => present,
    }
    service { 'apache2':
      ensure    => running,
      hasstatus => true,
      require   => Package['apache2'],
    }
    file { '/etc/apache2/sites-enabled/000-default':
      ensure  => absent,
      require => Package['apache2'],
      notify  => Service['apache2'],
    }
  }

  file { '/etc/apache2/sites-available/gdash.conf':
    owner   => root,
    group   => www-data,
    content => template('dc_gdash/gdash.conf.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  file { '/etc/apache2/sites-enabled/20-gdash.conf':
    ensure  => link,
    target  => '/etc/apache2/sites-available/gdash.conf',
    require => File['/etc/apache2/sites-available/gdash.conf'],
    notify  => Service['apache2'],
  }

  exec { 'enable-headers':
    command => '/usr/sbin/a2enmod headers',
    creates => '/etc/apache2/mods-enabled/headers.load',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  file { '/var/www/gdash/config/gdash.yaml':
    owner   => root,
    group   => www-data,
    content => template('dc_gdash/gdash.yaml.erb'),
    require => Vcsrepo['gdash_github'],
  }

}
