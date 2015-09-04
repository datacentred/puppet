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
  # are load balanced across all servers.
  haproxy::frontend { 'puppet':
    mode    => 'http',
    bind    => {
      ':8140' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify optional',
      ],
    },
    options => {
      'option'          => 'http-server-close',
      'default_backend' => 'puppet',
      'use_backend'     => [
        'puppetca if { path -m sub certificate }',
      ],
      'http-request'    => [
        'set-header X-SSL-Subject %{+Q}[ssl_c_s_dn]',
        'set-header X-Client-DN %{+Q}[ssl_c_s_dn]',
        'set-header X-Client-Verify SUCCESS if { ssl_c_verify 0 }',
        'set-header X-Client-Verify NONE unless { ssl_c_verify 0 }',
      ],
    },
  }

  haproxy::listen { 'puppetdb':
    collect_exported => false,
    mode             => 'http',
    bind             => {
      ':8081' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify required',
      ],
    },
    options          => {},
  }

  # Terminate SSL for web traffic.  Distribute to the relevant back-end
  # based on the host name prefix.  Public facing connections only e.g.
  # no firewalling as they are dependant on external services
  haproxy::frontend { 'http-alt':
    mode    => 'http',
    bind    => {
      ':8080' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/STAR_datacentred_services.crt',
      ],
    },
    options => {
      'option'       => 'http-server-close',
      'use_backend'  => [
        'jenkins if { hdr_beg(host) -i jenkins }',
      ],
      'http-request' => [
        'set-header X-Forwarded-Proto https',
      ],
    },
  }

  # HTTP Rules:
  # 1: Redirect to HTTPS
  haproxy::listen { 'http':
    mode    => 'http',
    bind    => {
      ':80' => [],
    },
    options => {
      'redirect' => 'scheme https',
    },
  }

  # HTTPS Rules:
  # 1: Unattended foreman traffic is allowed regardless to enable provisioning
  #    foreman handles authentication during this period
  # 2: All other traffic must have a valid certificate otherwise it is
  #    redirected to static error pages
  # 3: Other traffic is routed to the correct hostgroup via the HTTP host much
  #    like an apache virtual host
  haproxy::frontend { 'https':
    mode    => 'http',
    bind    => {
      ':443' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'crl-file /var/lib/puppet/ssl/crl.pem',
        'verify optional',
        'crt-ignore-err all',
      ],
    },
    options => {
      'option'       => [
        'httplog',
        'http-server-close',
      ],
      'use_backend'  => [
        'foreman if { hdr_beg(host) -i foreman } { path_beg /unattended }',
        'foreman if { hdr_beg(host) -i foreman } { path /api/v2/discovered_hosts/facts }',
        'static unless { ssl_c_used }',
        'static unless { ssl_c_verify 0 }',
        'foreman if { hdr_beg(host) -i foreman }',
        'icinga if { hdr_beg(host) -i icinga }',
        'ipam if { hdr_beg(host) -i ipam }',
        'kibana if { hdr_beg(host) -i kibana }',
        'stats if { hdr_beg(host) -i stats }',
      ],
      'http-request' => [
        'set-header X-Forwarded-Proto https',
      ],
    },
  }

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
        'verify required',
      ],
    },
    options          => {},
  }

  haproxy::listen { 'ldaps':
    collect_exported => false,
    mode             => 'tcp',
    bind             => {
      ':636' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify none',
      ],
    },
    options          => {},
  }

  haproxy::listen { 'log-courier':
    collect_exported => false,
    mode             => 'tcp',
    bind             => {
      ':55516' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify required',
      ],
    },
    options          => {},
  }

  haproxy::listen { 'beaver':
    collect_exported => false,
    mode             => 'tcp',
    bind             => {
      ':9999' => [
        'ssl',
        'no-sslv3',
        'ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
        'crt /etc/ssl/private/puppet.crt',
        'ca-file /var/lib/puppet/ssl/certs/ca.pem',
        'verify required',
      ],
    },
    options          => {},
  }

  haproxy::listen { 'elasticsearch':
    collect_exported => false,
    mode             => 'tcp',
    bind             => {
      ':9200' => [],
    },
    options          => {},
  }

  # Typical deployments use the proxy protocol between the balancer
  # and the mail servers.  However, as the traffic is behind a NAT
  # boundary this is pretty much pointless as it only allows mail
  # filtering on a per domain basis.
  haproxy::listen { 'smtp':
    collect_exported => false,
    mode             => 'tcp',
    bind             => {
      ':25' => [],
    },
    options          => {},
  }

  haproxy::backend { 'puppetca':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  haproxy::backend { 'puppet':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  haproxy::backend { 'foreman':
    collect_exported => false,
    options          => {
      'mode'    => 'http',
      'balance' => 'source',
    },
  }

  haproxy::backend { 'jenkins':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  haproxy::backend { 'icinga':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  haproxy::backend { 'ipam':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  haproxy::backend { 'kibana':
    collect_exported => false,
    options          => {
      'mode' => 'http',
    },
  }

  # Statistics backend
  haproxy::backend { 'stats':
    collect_exported => false,
    options          => {
      'mode'  => 'http',
      'stats' => [
        'enable',
        'uri /',
      ],
    },
  }

  # Backend to handle certificate errors and dispatch to the right place.
  # To explain the redirect rules a little bit:
  #
  # * If the client has no certificate and the path isn't /nocert.html
  #   redirect the client to that location.  When the redirected request
  #   comes back with the path of /nocert.html it doesn't get redirected.
  #   In this case with no certificate ssl_c_verify is zero so doesn't
  #   trigger the final catch all error case
  haproxy::backend { 'static':
    collect_exported => false,
    options          => {
      'mode'     => 'http',
      'redirect' => [
        'location /nocert.html if ! { ssl_c_used } ! { path /nocert.html }',
        'location /certexpired.html if { ssl_c_verify 10 } ! { path /certexpired.html }',
        'location /certrevoked.html if { ssl_c_verify 23 } ! { path /certrevoked.html }',
        'location /default.html if ! { ssl_c_verify 0 } ! { path /default.html }',
      ],
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

  haproxy::balancermember { 'puppetdb':
    listening_service => 'puppetdb',
    ports             => '8081',
    server_names      => [
      'puppetdb0.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.9',
    ],
    options           => 'ssl ca-file /var/lib/puppet/ssl/certs/ca.pem crt /etc/ssl/private/puppet.crt check check-ssl',
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
    ports             => '443',
    server_names      => [
      'foreman0.core.sal01.datacentred.co.uk',
      'foreman1.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.10',
      '10.30.192.205',
    ],
    options           => 'ssl ca-file /var/lib/puppet/ssl/certs/ca.pem crt /etc/ssl/private/puppet.crt check check-ssl',
  }

  haproxy::balancermember { 'foreman-puppet-proxy':
    listening_service => 'foreman-puppet-proxy',
    ports             => '8443',
    server_names      => 'puppetca.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.5',
    options           => 'ssl ca-file /var/lib/puppet/ssl/certs/ca.pem crt /etc/ssl/private/puppet.crt check check-ssl',
  }

  haproxy::balancermember { 'ldap':
    listening_service => 'ldaps',
    ports             => '389',
    server_names      => 'bonjour.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.100',
    options           => 'check',
  }

  haproxy::balancermember { 'smtp':
    listening_service => 'smtp',
    ports             => '10024',
    server_names      => [
      'mx0.core.sal01.datacentred.co.uk',
      'mx1.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.119',
      '10.30.192.121',
    ],
    options           => 'send-proxy check',
  }

  # TODO: Terminate SSL here
  haproxy::balancermember { 'log-courier':
    listening_service => 'log-courier',
    ports             => '55516',
    server_names      => [
      'logstash0.core.sal01.datacentred.co.uk',
      'logstash1.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.137',
      '10.30.192.140',
    ],
    options           => 'ssl ca-file /var/lib/puppet/ssl/certs/ca.pem crt /etc/ssl/private/puppet.crt check check-ssl',
  }

  haproxy::balancermember { 'beaver':
    listening_service => 'beaver',
    ports             => '9999',
    server_names      => [
      'logstash0.core.sal01.datacentred.co.uk',
      'logstash1.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.137',
      '10.30.192.140',
    ],
    options           => 'check',
  }

  haproxy::balancermember { 'kibana':
    listening_service => 'kibana',
    ports             => '80',
    server_names      => [
      'logstash0.core.sal01.datacentred.co.uk',
      'logstash1.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.137',
      '10.30.192.140',
    ],
    options           => 'check',
  }

  haproxy::balancermember { 'ipam':
    listening_service => 'ipam',
    ports             => '80',
    server_names      => [
      'ipam0.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.184',
    ],
    options           => 'check',
  }

  haproxy::balancermember { 'icinga':
    listening_service => 'icinga',
    ports             => 80,
    server_names      => [
      'icinga0.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.123',
    ],
    options           => 'check',
  }

  haproxy::balancermember { 'elasticsearch':
    listening_service => 'elasticsearch',
    ports             => '9200',
    server_names      => [
      'elasticsearch0.core.sal01.datacentred.co.uk',
      'elasticsearch1.core.sal01.datacentred.co.uk',
      'elasticsearch2.core.sal01.datacentred.co.uk',
    ],
    ipaddresses       => [
      '10.30.192.130',
      '10.30.192.132',
      '10.30.192.134',
    ],
    options           => 'check',
  }

  # TODO: Move me to a real machine
  haproxy::balancermember { 'static':
    listening_service => 'static',
    ports             => '80',
    server_names      => 'jenkins0.core.sal01.datacentred.co.uk',
    ipaddresses       => '10.30.192.7',
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
