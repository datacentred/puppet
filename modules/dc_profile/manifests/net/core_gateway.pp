# == Class: dc_profile::net::core_gateway
#
# Haproxy and Keepalived configuration for core gateways
#
class dc_profile::net::core_gateway {

  include ::puppet
  include ::haproxy
  include ::keepalived

  # Terminate SSL for puppet, setting the correct verify variables.
  # Certificate requests are routed to the CA back-end, all others
  # are load balanced across all servers.  The upstream firewall
  # only allows connections from cloud cell NAT pools
  haproxy::frontend { 'puppet':
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':8140' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify optional',
      ],
    },
    options          => {
      'acl'             => 'is_puppetca path -m sub certificate',
      'default_backend' => 'puppet',
      'use_backend'     => 'puppetca if is_puppetca',
      'http-request'    => [
        'set-header X-SSL-Subject %{+Q}[ssl_c_s_dn]',
        'set-header X-Client-DN %{+Q}[ssl_c_s_dn]',
        'set-header X-Client-Verify SUCCESS if { ssl_c_verify 0 }',
        'set-header X-Client-Verify NONE unless { ssl_c_verify 0 }',
      ],
    },
  }

  # Terminate SSL for web traffic.  Distribute to the relevant back-end
  # based on the host name prefix.  Public facing connections only e.g.
  # no firewalling as they are dependant on external services
  haproxy::frontend { 'http-alt':
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':8080' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/STAR_datacentred_services.crt',
      ],
    },
    options          => {
      'acl '                => 'is_jenkins hdr_beg(host) -i jenkins',
      'use_backend jenkins' => 'if is_jenkins',
      'http-request'        => [
        'set-header X-Forwarded-Proto https',
      ],
    },
  }

  # Foreman is rubbish and needs 443 all to itself with a puppet signed certificate
  # meaning anything using the datacentred.services wildcard cert is a second class
  # citizen and has to run elsewhere, and support a different port, which could be
  # an arse.  It may be worth having 2 VIPs, one for puppety traffic and one for
  # regular traffic
  haproxy::listen { 'foreman':
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':443' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify optional',
      ],
    },
    options          => {
      'http-request' => [
        'set-header X-Forwarded-Proto https',
      ],
    },
  }

  # Checks 'check' and 'check check-ssl' are disabled because the Layer 6 response
  # is invalid, e.g. Foreman is rubbish yet again
  haproxy::listen { 'foreman-puppet-proxy':
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':8443' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify none',
      ],
    },
  }

  haproxy::listen { 'ldaps':
    collect_exported => false,
    mode             => 'tcp',
    bind             => {
      ':636' => []
    },
  }

  haproxy::listen { 'stats':
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':1936' => [],
    },
    options          => {
      'stats' => [
        'enable',
        'uri /',
      ],
    },
  }

  haproxy::backend { 'puppetca':
    collect_exported => false,
    options          => {
      mode => 'http',
    },
  }

  haproxy::backend { 'puppet':
    collect_exported => false,
    options          => {
      mode => 'http',
    },
  }

  haproxy::backend { 'jenkins':
    collect_exported => false,
    options          => {
      mode => 'http',
    },
  }

  haproxy::balancermember { 'puppetca':
    listening_service => 'puppetca',
    ports             => '8140',
    server_names      => [
      'puppetca.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.5',
    ],
    options           => 'check',
  }

  haproxy::balancermember { 'puppet':
    listening_service => 'puppet',
    ports             => '8140',
    server_names      => [
      'puppetca.core.sal01.datacentred.co.uk',
      'puppet0.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.5',
      '10.30.192.6',
    ],
    options           => 'check',
  }

  haproxy::balancermember { 'jenkins':
    listening_service => 'jenkins',
    ports             => '8080',
    server_names      => 'jenkins0.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.7',
    options           => 'check',
  }

  haproxy::balancermember { 'foreman':
    listening_service => 'foreman',
    ports             => '80',
    server_names      => 'foreman0.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.10',
    options           => 'check',
  }

  haproxy::balancermember { 'foreman-puppet-proxy':
    listening_service => 'foreman-puppet-proxy',
    ports             => '8443',
    server_names      => 'puppetca.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.5',
    options           => 'ssl ca-file /var/lib/puppet/ssl/certs/ca.pem crt /etc/ssl/private/puppet.crt',
  }

  haproxy::balancermember { 'ldaps':
    listening_service => 'ldaps',
    ports             => '636',
    server_names      => 'bonjour.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.100',
    options           => 'check',
  }

  keepalived::vrrp::instance { 'VI_1':
    interface         => 'em1',
    state             => 'SLAVE',
    virtual_router_id => '1',
    priority          => '100',
    virtual_ipaddress => '10.30.192.2/24',
  }

  keepalived::vrrp::instance { 'VI_2':
    interface         => 'em2',
    state             => 'SLAVE',
    virtual_router_id => '2',
    priority          => '100',
    virtual_ipaddress => '185.43.217.42/29',
  }

}
