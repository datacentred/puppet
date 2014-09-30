# Class: dc_profile::openstack::haproxy_icehouse
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

class dc_profile::openstack::haproxy_icehouse {

  include ::dc_ssl::haproxy

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

  # Keystone Auth
  haproxy::listen { 'keystone-auth':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '5000',
    bind_options => [
      'ssl',
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
      'crt /etc/ssl/certs/STAR_datacentred_io.pem',
      'crt /etc/ssl/certs/STAR_sal01_datacentred_co_uk.pem',
      'ciphers HIGH:!RC4:!MD5:!aNULL:!eNULL:!EXP:!LOW:!MEDIUM',
    ],
    options      => {
      'option'   => ['tcpka', 'httpchk', 'tcplog'],
      'balance'  => 'source',
      'rspadd'   => 'Strict-Transport-Security:\ max-age=60',
    },
  }

  # Glance Registry
  haproxy::listen { 'glance-registry':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '9191',
    bind_options => [
      'ssl',
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
  haproxy::listen { 'nova-metadata':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8775',
    bind_options => [
      'ssl',
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

  # Cinder
  haproxy::listen { 'cinder':
    ipaddress    => '*',
    mode         => 'http',
    ports        => '8776',
    bind_options => [
      'ssl',
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
    ipaddress    => '*',
    mode         => 'tcp',
    ports        => '3306',
    options      => {
      'option'  => ['httpchk'],
      'balance' => 'source',
    },
  }

}
