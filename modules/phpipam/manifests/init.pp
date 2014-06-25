class phpipam(
  $version = '1.0',
  $db_host = 'localhost',
  $db_user = 'phpipam',
  $db_pass = 'phpipam',
  $db_name = 'phpipam',
) {

  include wget

  file { '/var/www/phpipam':
    ensure => directory,
  } ->

  file { '/var/www/phpipam/versions':
    ensure => directory,
  } ->

  file { "/var/www/phpipam/versions/${version}":
    ensure => directory,
  } ->

  wget::fetch { "http://downloads.sourceforge.net/project/phpipam/phpipam-${version}.tar":
    destination => "/tmp/phpipam-${version}.zip",
    cache_dir   => '/var/cache/wget',
  } ->

  exec { "extract_phpipam_${version}":
    command => "/bin/tar -xvf /tmp/phpipam-${version}.zip -C /var/www/phpipam/versions/${version}",
    creates => "/var/www/phpipam/versions/${version}/phpipam",
  } ->

  file { "/var/www/phpipam/versions/${version}/phpipam/config.php":
    content => template('phpipam/config.php.erb')
  } ->

  file { '/var/www/phpipam/latest':
    ensure => symlink,
    target => "/var/www/phpipam/versions/${version}/phpipam",
  }

}
