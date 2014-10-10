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

  # Get the IP of the VIP to which we want haproxy to bind
  $vrhash = hiera(virtual_routers)
  $vip = $vrhash['compute_api_int']['vip']

  # Ensure HAProxy is restarted whenever SSL certificates are changed
  Class['dc_ssl::haproxy'] ~> Haproxy::Listen <||>

  # Keystone Auth
  haproxy::listen { 'icehouse-keystone-auth':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-keystone-admin':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-glance-api':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-glance-registry':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-neutron':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-nova-compute':
    ipaddress    => $vip,
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
  # TODO: Renable SSL for this service when we go to Juno
  haproxy::listen { 'icehouse-nova-metadata':
    ipaddress    => $vip,
    mode         => 'http',
    ports        => '8775',
    options      => {
      'option'  => ['tcpka', 'httpchk', 'tcplog'],
      'balance' => 'source',
    },
  }

  # Cinder
  haproxy::listen { 'icehouse-cinder':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-horizon':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-novncproxy':
    ipaddress    => $vip,
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
  haproxy::listen { 'icehouse-galera':
    ipaddress => $vip,
    mode      => 'tcp',
    ports     => '3306',
    options   => {
      'option'         => ['httpchk'],
      'balance'        => 'source',
      'timeout client' => '30000s',
      'timeout server' => '30000s',
    },
  }

}
