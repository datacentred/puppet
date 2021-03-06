# == Class: dc_profile::net::phpipam
#
class dc_profile::net::phpipam {
  include php
  include php::pear

  include apache
  include apache::mod::php
  include apache::mod::rewrite
  include ::apache::mod::status

  include ::mysql::server
  include ::mysql::server::backup

  include ::phpipam

  create_resources('mysql::db', hiera('databases'))

  apache::vhost { 'phpipam':
    servername    => $::fqdn,
    docroot       => '/var/www/phpipam',
    override      => 'all',
    port          => 80,
    serveraliases => [
      $::hostname,
      'ipam',
      'ipam.datacentred.services',
      "ipam.${::domain}",
    ],
  }

  # Required for LDAPS support to trust the server certificate
  ca_certificate { 'puppet-ca':
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  }

}
