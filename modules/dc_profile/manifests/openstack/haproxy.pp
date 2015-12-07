# Class: dc_profile::openstack::haproxy
#
# Configures HAproxy with SSL support
# for the various OpenStack API endpoints
#
# Parameters:
#
# Actions:

class dc_profile::openstack::haproxy {

  include ::haproxy
  include ::dc_haproxy
  include ::dc_ssl::haproxy
  include ::dc_icinga::hostgroup_haproxy

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

  $haproxy_stats_user     = hiera(haproxy_stats_user)
  $haproxy_stats_password = hiera(haproxy_stats_password)

  $internal_vip = hiera(os_api_vip)

  dc_haproxy::service { 'openstack': }
  dc_haproxy::service { 'galera': }

  haproxy::instance { 'openstack':
    require        => Class['::dc_haproxy'],
    global_options => {
      'chroot' => '/var/lib/haproxy/openstack',
    }
  }

  haproxy::instance_service { 'openstack':
    require => ::Dc_haproxy::Service['openstack'],
  }

  haproxy::instance { 'galera':
    require        => Class['::dc_haproxy'],
    global_options => {
      'chroot' => '/var/lib/haproxy/galera',
    }
  }

  haproxy::instance_service { 'galera':
    require => ::Dc_haproxy::Service['galera'],
  }

  # Redirect all non-SSL requests to SSL
  haproxy::listen { 'http-to-https-redirect':
    instance  => 'openstack',
    ipaddress => '*',
    mode      => 'http',
    ports     => '80',
    options   => {
      'redirect' => 'scheme https if !{ ssl_fc }',
    }
  }

  # HAProxy Statistics
  haproxy::listen { 'haproxy-stats':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':1936' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'stats'  => [
        'enable',
        'uri /',
        'hide-version',
        "auth ${haproxy_stats_user}:${haproxy_stats_password}",
      ],
      'rspadd' => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Keystone Auth
  haproxy::listen { 'keystone-auth':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':5000' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Keystone Admin
  haproxy::listen { 'keystone-admin':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':35357' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Glance API
  haproxy::listen { 'glance-api':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':9292' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Glance Registry
  haproxy::listen { 'glance-registry':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':9191' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Neutron
  haproxy::listen { 'neutron':
    instance         => 'openstack',
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':9696' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options          => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Nova Compute
  haproxy::listen { 'nova-compute':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':8774' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Nova Metadata
  # TODO: Renable SSL for this service when we go to Juno
  haproxy::listen { 'nova-metadata':
    instance  => 'openstack',
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
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':8773' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Cinder
  haproxy::listen { 'cinder':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':8776' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Horizon
  haproxy::listen { 'horizon':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':443' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # NoVNC Proxy
  haproxy::listen { 'novncproxy':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':6080' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Galera
  haproxy::listen { 'galera':
    instance         => 'galera',
    collect_exported => true,
    ipaddress        => $internal_vip,
    mode             => 'tcp',
    ports            => '3306',
    options          => {
      'option'         => ['httpchk'],
      'balance'        => 'source',
      'timeout client' => '8h',
      'timeout server' => '8h',
    },
  }

  # Ceilometer
  haproxy::listen { 'ceilometer':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':8777' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'         => ['tcpka', 'tcplog'],
      'balance'        => 'source',
      'rspadd'         => 'Strict-Transport-Security:\ max-age=31536000',
      'timeout client' => '180s',
      'timeout server' => '180s',
    },
  }

  # Heat
  haproxy::listen { 'heat':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':8004' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'tcplog', 'forwardfor'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
      'reqadd'  => 'X-Forwarded-Proto:\ https if { ssl_fc }',
    },
  }

  # Heat CloudFormation
  haproxy::listen { 'heat-cfn':
    instance => 'openstack',
    mode     => 'http',
    bind     => {
      ':8000' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options  => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

}
