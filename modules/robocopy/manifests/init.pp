# Icons and stuff for robocopy/hipchat
class robocopy {

  include apache

  $docroot = '/var/www/robocopy'

  file { $docroot:
    ensure  => 'directory',
    source  => 'puppet:///modules/robocopy',
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
  }

  dc_apache::vhost { 'robocopy':
    docroot => $docroot,
  }

}
