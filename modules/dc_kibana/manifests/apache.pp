# == Class: dc_kibana::apache
#
class dc_kibana::apache {

  dc_apache::vhost { 'kibana':
    docroot => '/var/www/kibana',
    cname   => false,
    require => File['/var/www'],
  }

}
