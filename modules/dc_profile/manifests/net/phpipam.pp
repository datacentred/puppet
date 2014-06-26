class dc_profile::net::phpipam {
  include php
  include php::pear
  include php::extension::mysql
  include php::extension::ldap

  include apache
  include apache::mod::php
  include apache::mod::rewrite

  include ::phpipam

  apache::vhost { 'phpipam':
    servername => "phpipam.${::domain}",
    docroot    => '/var/www/phpipam/latest',
    override   => 'all',
    port       => 80,
  }

  @@dns_resource { "phpipam.${::domain}/CNAME":
    rdata => $::fqdn,
  }
}
