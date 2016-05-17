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

  # haproxy listeners scoped to the environment-specific role class 
  # For now this is just Galera and the stats interface
  create_resources(haproxy::listen, hiera_hash('dc_profile::openstack::haproxy::listeners'))

  # Keystone Auth
  haproxy::listen { 'keystone-auth':
    mode    => 'http',
    bind    => {
      ':5000' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Keystone Admin
  haproxy::listen { 'keystone-admin':
    mode    => 'http',
    bind    => {
      ':35357' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Glance API
  haproxy::listen { 'glance-api':
    mode    => 'http',
    bind    => {
      ':9292' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Glance Registry
  haproxy::listen { 'glance-registry':
    mode    => 'http',
    bind    => {
      ':9191' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Neutron
  haproxy::listen { 'neutron':
    mode    => 'http',
    bind    => {
      ':9696' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Nova Compute
  haproxy::listen { 'nova-compute':
    mode    => 'http',
    bind    => {
      ':8774' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'         => ['tcpka', 'httpchk', 'tcplog'],
      'balance'        => 'source',
      'rspadd'         => 'Strict-Transport-Security:\ max-age=31536000',
      'timeout client' => '180s',
      'timeout server' => '180s',
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
    mode    => 'http',
    bind    => {
      ':8773' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Cinder
  haproxy::listen { 'cinder':
    mode    => 'http',
    bind    => {
      ':8776' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Horizon
  haproxy::listen { 'horizon':
    mode    => 'http',
    bind    => {
      ':443' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # NoVNC Proxy
  haproxy::listen { 'novncproxy':
    mode    => 'http',
    bind    => {
      ':6080' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  # Ceilometer
  haproxy::listen { 'ceilometer':
    mode    => 'http',
    bind    => {
      ':8777' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'         => ['tcpka', 'tcplog'],
      'balance'        => 'source',
      'rspadd'         => 'Strict-Transport-Security:\ max-age=31536000',
      'timeout client' => '180s',
      'timeout server' => '180s',
    },
  }

  # Heat
  haproxy::listen { 'heat':
    mode    => 'http',
    bind    => {
      ':8004' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'tcplog', 'forwardfor'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
      'reqadd'  => 'X-Forwarded-Proto:\ https if { ssl_fc }',
    },
  }

  # Heat CloudFormation
  haproxy::listen { 'heat-cfn':
    mode    => 'http',
    bind    => {
      ':8000' => [
        'ssl',
        'no-sslv3',
        'crt /etc/ssl/certs/STAR_datacentred_io.pem',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
      ],
    },
    options => {
      'option'  => ['tcpka', 'tcplog'],
      'balance' => 'source',
      'rspadd'  => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

}
