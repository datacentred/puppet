class dc_kibana::apache {
  apache::vhost { 'logstash':
    docroot       => '/var/www/kibana',
    port          => '80',
    serveradmin   => hiera(sysmailaddress),
    serveraliases => [ 'kibana' ],
    require       => File['/var/www/kibana'],
  }
}
