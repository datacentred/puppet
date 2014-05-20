class dc_profile::perf::network_weathermap {
  include php
  include php::pear
  include php::extension::gd
  include php::extension::curl
  
  include apache
  include apache::mod::php

  include dc_network_weathermap

  cron { 'network-weathermap':
    command => 'cd /opt/network-weathermap/latest && php weathermap --config configs/DataCentred.conf',
    hour    => '*',
    minute  => '*',
    month   => '*',
  }

  apache::vhost { 'network-weathermap':
    servername => "weathermap.${::domain}",
    docroot    => '/opt/network-weathermap/latest',
    port       => 80, 
  }

  @@dns_resource { "weathermap.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}
