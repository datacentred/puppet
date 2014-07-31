class phpipam(
  $version = 'v1.1.0',
  $db_host = 'localhost',
  $db_user = 'phpipam',
  $db_pass = 'phpipam',
  $db_name = 'phpipam',
) {

  ensure_packages(['git'])

  vcsrepo { "/var/www/phpipam":
    ensure   => present,
    provider => git,
    revision => $version,
    source   => 'https://github.com/datacentred/phpipam.git',
  } ->

  file { '/var/www/phpipam/config.php':
    content => template('phpipam/config.php.erb')
  }

}
