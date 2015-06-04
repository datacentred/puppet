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

  include ::haproxy
  include ::dc_ssl::haproxy
  include ::dc_icinga::hostgroup_haproxy

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

  $haproxy_stats_user     = hiera(haproxy_stats_user)
  $haproxy_stats_password = hiera(haproxy_stats_password)

  $internal_vip = hiera(os_api_vip)

  # Redirect all non-SSL requests to SSL
  haproxy::listen { 'http-to-https-redirect':
    ipaddress => '*',
    mode      => 'http',
    ports     => '80',
    options   => {
      'redirect' => 'scheme https if !{ ssl_fc }',
    }
  }

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
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress => '*',
    mode      => 'http',
    ports     => '8775',
    options   => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }

  # Amazon EC2-compatible nova API endpoint
  haproxy::listen { 'nova-ec2':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8773',
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

  # Cinder
  haproxy::listen { 'cinder':
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress    => '*',
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
    ipaddress => $internal_vip,
    mode      => 'tcp',
    ports     => '3306',
    options   => {
      'option'         => ['httpchk'],
      'balance'        => 'source',
      'timeout client' => '8h',
      'timeout server' => '8h',
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
      'option'  => ['tcpka', 'tcplog', 'forwardfor'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=60',
      'reqadd'  => 'X-Forwarded-Proto:\ https if { ssl_fc }',
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
