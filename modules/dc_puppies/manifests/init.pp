# Scarlett for HipChat
class dc_puppies {

  include apache

  $docroot = '/var/www/puppies'

  file { $docroot:
    ensure  => 'directory',
    source  => 'puppet:///modules/dc_puppies',
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
  }

  dc_apache::vhost { 'puppies':
    docroot => $docroot,
  }

}
