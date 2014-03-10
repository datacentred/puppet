class dc_kibana::apache {
  apache::vhost { 'logstash':
    docroot     => '/var/www/kibana',
    port        => '80',
    serveradmin => hiera(sysmailaddress),
    require     => File['/var/www/kibana'],
  }
}
