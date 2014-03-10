# Ponies for HipChat
class dc_ponies {

  include apache

  $docroot = '/var/www/ponies'

  file { $docroot:
    ensure  => 'directory',
    source  => 'puppet:///modules/dc_ponies',
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
  }

  apache::vhost { "ponies.${::domain}":
    docroot => $docroot,
    port    => '80',
  }

  @@dns_resource { "ponies.${::domain}/CNAME":
    rdata => $::fqdn,
  }

}
