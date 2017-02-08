# Class: dc_profile::puppet::puppetdb
#
# Provisions a puppetdb service node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::puppet::puppetdb {

  # See role specific apache config in hiera
  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::proxy_connect
  include ::apache::mod::proxy_http
  include ::apache::mod::status

  apache::vhost { 'puppetdb-dashboard':
    docroot             => '/var/www/html',
    servername          => 'localhost',
    port                => 80,
    proxy_preserve_host => true,
    proxy_pass          => [
      {
        'path'         => '/',
        'url'          => 'http://localhost:8080/',
        'reverse_urls' => 'http://localhost:8080/',
      },
    ],
  }

  include ::puppetdb::server

  # Puppetdb with default settings OOM kills itself so hack
  # the defaults to increase memory to 2GB
  exec { 'sed -i "s/-Xmx[[:digit:]]\+m/-Xmx2048m/" /etc/default/puppetdb':
    unless  => 'grep Xmx2048m /etc/default/puppetdb',
    require => Package['puppetdb'],
    notify  => Service['puppetdb'],
  }

  include ::dc_icinga::hostgroup_puppetdb

}

