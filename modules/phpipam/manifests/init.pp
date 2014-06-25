class phpipam(
  $version = '1.0',
  $db_host = 'localhost',
  $db_user = 'phpipam',
  $db_pass = 'phpipam',
  $db_name = 'phpipam',
) {

  include wget

  file { '/opt/phpipam':
    ensure => directory,
  } ->

  file { '/opt/phpipam/versions':
    ensure => directory,
  } ->

  file { "/opt/phpipam/versions/${version}":
    ensure => directory,
  } ->

  wget::fetch { "http://downloads.sourceforge.net/project/phpipam/phpipam-${version}.tar":
    destination => "/tmp/phpipam-${version}.zip",
    cache_dir   => '/var/cache/wget',
  } ->

  exec { "extract_phpipam_${version}":
    command => "/bin/tar -xvf /tmp/phpipam-${version}.zip -C /opt/phpipam/versions/${version}",
    creates => "/opt/phpipam/versions/${version}/phpipam",
  } ->

  file { "/opt/phpipam/versions/${version}/phpipam/config.php":
    content => template('phpipam/config.php.erb')
  } ->

  file { '/opt/phpipam/latest':
    ensure => symlink,
    target => "/opt/phpipam/versions/${version}/phpipam",
  }

}
