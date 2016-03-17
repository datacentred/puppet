# == Class: dc_profile::ceph::radosgw_lb
#
class dc_profile::ceph::radosgw_lb {

  include ::haproxy
  include ::keepalived
  include ::dc_ssl::storage

  # Network hacks that foreman cannot handle
  $domain      = 'storage.datacentred.io'
  # WARNING: ensure this A record is resolvable from the puppet master
  #          e.g. CloudFlare
  $myip        = get_ip_addr("${::hostname}.${domain}")
  $ceph_public = 'p1p1' # Internet facing
  $ceph_lb     = 'p1p2' # Internally facing

  augeas { $ceph_public :
    context => '/files/etc/network/interfaces',
    changes => [
      "set auto[child::1 = '${ceph_public}']/1 ${ceph_public}",
      "set iface[. = '${ceph_public}'] ${ceph_public}",
      "set iface[. = '${ceph_public}']/family inet",
      "set iface[. = '${ceph_public}']/method static",
      "set iface[. = '${ceph_public}']/address ${myip}",
      "set iface[. = '${ceph_public}']/netmask 255.255.255.240",
      "set iface[. = '${ceph_public}']/post-up 'ip route replace default via 185.43.218.49'",
      "set iface[. = '${ceph_public}']/post-down 'ip route replace default via 10.10.9.1'",
    ],
  }

  augeas { $ceph_lb:
    context => '/files/etc/network/interfaces',
    changes => [
      "set auto[child::1 = '${ceph_lb}']/1 ${ceph_lb}",
      "set iface[. = '${ceph_lb}'] ${ceph_lb}",
      "set iface[. = '${ceph_lb}']/family inet",
      "set iface[. = '${ceph_lb}']/method dhcp",
      "set iface[. = '${ceph_lb}']/post-up[1] 'ip route add 10.10.0.0/16 via 10.10.9.1'",
      "set iface[. = '${ceph_lb}']/post-up[2] 'ip route add 10.253.2.0/24 via 10.10.9.1'",
      "set iface[. = '${ceph_lb}']/post-down[1] 'ip route del 10.10.0.0/16 via 10.10.9.1'",
      "set iface[. = '${ceph_lb}']/post-down[2] 'ip route del 10.253.2.0/24 via 10.10.9.1'",
    ],
  }

  # S3/Swift endpoints listen in HTTP and HTTPS ports
  # SSL is terminated at the frontend and forwarded in plain text to the RADOS gateways
  haproxy::frontend { 'http':
    mode    => 'http',
    bind    => {
      ':80' => [],
    },
    options => {
      'option'          => [
        'tcpka',
        'httpchk GET / HTTP/1.1\r\nHost:\ storage.datacentred.io\r\nUser-Agent:\ HAProxy',
        'httplog',
        'forwardfor',
      ],
      'balance'         => 'source',
      'default_backend' => 'http',
    },
  }

  haproxy::frontend { 'https':
    mode    => 'http',
    bind    => {
      ':443' => [
        'ssl',
        'no-sslv3',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
        'crt /etc/ssl/private/STAR_storage_datacentred_io.crt',
      ],
    },
    options => {
      'option'          => [
        'tcpka',
        'httpchk GET / HTTP/1.1\r\nHost:\ storage.datacentred.io\r\nUser-Agent:\ HAProxy',
        'httplog',
        'forwardfor',
      ],
      'balance'         => 'source',
      'default_backend' => 'http',
      'rspadd'          => [
        'Strict-Transport-Security:\ max-age=31536000',
      ],
    },
  }

  haproxy::backend { 'http':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  haproxy::balancermember { 'http':
    listening_service => 'http',
    ports             => '80',
    server_names      => [
      'ceph-rgw-0.sal01.datacentred.co.uk',
      'ceph-rgw-1.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.10.9.32',
      '10.10.9.38',
    ],
    options           => 'check',
  }

  # The statistics interface listens on port 1936 over SSL
  # The port is protected with puppet X.509 certificates so only trusted users
  # and servers (e.g. Icinga) are able to connect
  haproxy::listen { 'haproxy-stats':
    mode    => 'http',
    bind    => {
      ':1936' => [
        'ssl',
        'no-sslv3',
        'ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify required',
      ],
    },
    options => {
      'stats'  => [
        'enable',
        'uri /',
      ],
      'rspadd' => 'Strict-Transport-Security:\ max-age=31536000',
    },
  }

  keepalived::vrrp::instance { 'VI_70':
    interface         => 'p1p2',
    state             => 'SLAVE',
    virtual_router_id => 70,
    priority          => 100,
    virtual_ipaddress => '10.10.9.2/24',
  }

  keepalived::vrrp::instance { 'VI_71':
    interface         => 'p1p1',
    state             => 'SLAVE',
    virtual_router_id => 71,
    priority          => 100,
    virtual_ipaddress => '185.43.218.55/28',
  }

}
