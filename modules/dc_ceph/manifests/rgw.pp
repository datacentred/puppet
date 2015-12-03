# == Class: dc_ceph::rgw
#
# Configures an Apache head for a rados gateway.
#
# === Description
#
# Installs the fastcgi script into the document root, adds a browser match
# rule to flag HAProxy health check traffic and filter it out of the logs.
# The log formats are defined in hiera.  Ports are opened up for http and
# https traffic to support end to end encryption if required.
#
class dc_ceph::rgw {

  include ::apache
  include ::apache::mod::fastcgi

  Class['::apache'] ->

  file { '/var/www/s3gw.fcgi':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    content => template('dc_ceph/s3gw.fcgi.erb'),
  }

  apache::custom_config { 'haproxy_browsermatch':
    content => 'BrowserMatch ^HAProxy$ healthcheck',
  }

  apache::vhost { 'radosgw':
    servername         => $::fqdn,
    docroot            => '/var/www',
    port               => 80,
    serveraliases      => [
      "*.${::fqdn}",
    ],
    rewrites           => [
      {
        rewrite_rule => [
          '^/(.*) /s3gw.fcgi?%{QUERY_STRING} [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]',
        ],
      },
    ],
    fastcgi_server     => '/var/www/s3gw.fcgi',
    fastcgi_socket     => "/var/run/ceph/ceph.client.radosgw.${::hostname}.fastcgi.sock",
    fastcgi_dir        => '/var/www',
    access_log_format  => 'radosgw',
    access_log_env_var => '!healthcheck',
  }

  apache::vhost { 'radosgw-ssl':
      servername         => $::fqdn,
      docroot            => '/var/www',
      port               => 443,
      ssl                => true,
      ssl_cert           => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
      ssl_key            => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
      serveraliases      => [
        "*.${::fqdn}",
      ],
      rewrites           => [
        {
          rewrite_rule => [
            '^/(.*) /s3gw.fcgi?%{QUERY_STRING} [E=HTTP_AUTHORIZATION:%{HTTP:Authorization},L]',
          ],
        },
      ],
      fastcgi_socket     => "/var/run/ceph/ceph.client.radosgw.${::hostname}.fastcgi.sock",
      fastcgi_dir        => '/var/www',
      access_log_format  => 'radosgw',
      access_log_env_var => '!healthcheck',
  }

}
