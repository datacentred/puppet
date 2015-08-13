# == Class: dc_profile::net::phpipam
#
class dc_profile::net::phpipam {
  include php
  include php::pear
  include php::extension::mysql
  include php::extension::ldap

  include apache
  include apache::mod::php
  include apache::mod::rewrite

  include ::mysql::server
  include ::mysql::server::monitor
  include ::mysql::server::backup
  include ::dc_collectd::agent::mysql

  include ::phpipam

  create_resources('mysql::db', hiera('databases'))

  apache::vhost { 'phpipam':
    servername    => $::fqdn,
    docroot       => '/var/www/phpipam',
    override      => 'all',
    port          => 80,
    serveraliases => [
      $::hostname,
    ],
  }

  # Required for LDAPS support to trust the server certificate
  ca_certificate { 'puppet-ca':
    source => '/var/lib/puppet/ssl/certs/ca.pem',
  }

}
