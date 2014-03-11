class dc_kibana::apache {

  dc_apache::vhost { 'kibana':
    docroot => '/var/www/kibana',
    require => File['/var/www/kibana'],
  }

}
