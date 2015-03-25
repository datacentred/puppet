# == Class: dc_kibana::apache
#
class dc_kibana::apache {

  apache::vhost { "kibana.${::domain}":
    port          => 80,
    docroot       => '/var/www/kibana',
    serveraliases => [ 'kibana' ],
  }

}
