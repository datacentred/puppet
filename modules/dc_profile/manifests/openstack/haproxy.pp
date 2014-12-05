# Class: dc_profile::openstack::haproxy
#
# Configures HAproxy with SSL support
# for the various OpenStack API endpoints
#
# Parameters:
#
# Actions:
#
# Requires: datacentred-haproxy, dev version of haproxy that
#           includes SSL support
#
# Sample Usage:
#
# TODO: Enable SSL endpoints once we've stood up the necessary
# infrastructure

class dc_profile::openstack::haproxy {

  include ::dc_ssl::haproxy
  include ::haproxy

  # Get the IP of the VIP to which we want haproxy to bind
  $vrhash = hiera(virtual_routers)
  $internal_vip = $vrhash['compute_api_int']['vip']
  $external_vip = $vrhash['compute_api_ext']['vip']

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

  $haproxy_stats_user     = hiera(haproxy_stats_user)
  $haproxy_stats_password = hiera(haproxy_stats_password)

  # HAProxy Statistics
  haproxy::listen { 'haproxy-stats':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '1936',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'stats'  => [
        'enable',
        'uri /',
        'hide-version',
        "auth ${haproxy_stats_user}:${haproxy_stats_password}",
      ],
      'rspadd' => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Keystone Auth
  haproxy::listen { 'keystone-auth':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '5000',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Keystone Admin
  haproxy::listen { 'keystone-admin':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '35357',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Glance API
  haproxy::listen { 'glance-api':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '9292',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Glance Registry
  haproxy::listen { 'glance-registry':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '9191',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Neutron
  haproxy::listen { 'neutron':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '9696',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Nova Compute
  haproxy::listen { 'nova-compute':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '8774',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Nova Metadata
  # TODO: Renable SSL for this service when we go to Juno
  haproxy::listen { 'nova-metadata':
    ipaddress => [ $internal_vip, $external_vip ],
    mode      => 'http',
    ports     => '8775',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }

  # Cinder
  haproxy::listen { 'cinder':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '8776',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Horizon
  haproxy::listen { 'horizon':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '443',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # NoVNC Proxy
  haproxy::listen { 'novncproxy':
    ipaddress    => [ $internal_vip, $external_vip ],
    mode         => 'http',
    ports        => '6080',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Galera
  haproxy::listen { 'galera':
    ipaddress => [ $internal_vip, $external_vip ],
    mode      => 'tcp',
    ports     => '3306',
    options   => {
      'option'         => ['httpchk'],
      'balance'        => 'source',
      'timeout client' => '30000s',
      'timeout server' => '30000s',
    },
  }

  # Ceilometer
  haproxy::listen { 'ceilometer':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8777',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Heat
  haproxy::listen { 'heat':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8004',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Heat CloudFormation
  haproxy::listen { 'heat-cfn':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8000',
    bind_options => [
      'ssl',
      'no-sslv3',
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
    },
  }

}
