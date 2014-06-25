class phpipam(
  $version = '1.0',
  $db_host = 'localhost',
  $db_user = 'phpipam',
  $db_pass = 'phpipam',
  $db_name = 'phpipam',
) {

  include wget

  file { '/var/phpipam':
    ensure => directory,
  } ->

  file { '/var/phpipam/versions':
    ensure => directory,
  } ->

  file { "/var/phpipam/versions/${version}":
    ensure => directory,
  } ->

  wget::fetch { "http://downloads.sourceforge.net/project/phpipam/phpipam-${version}.tar":
    destination => "/tmp/phpipam-${version}.zip",
    cache_dir   => '/var/cache/wget',
  } ->

  exec { "extract_phpipam_${version}":
    command => "/bin/tar -xvf /tmp/phpipam-${version}.zip -C /var/phpipam/versions/${version}",
    creates => "/var/phpipam/versions/${version}/phpipam",
  } ->

  file { "/var/phpipam/versions/${version}/phpipam/config.php":
    content => template('phpipam/config.php.erb')
  } ->

  file { '/var/phpipam/latest':
    ensure => symlink,
    target => "/var/phpipam/versions/${version}/phpipam",
  }

}
