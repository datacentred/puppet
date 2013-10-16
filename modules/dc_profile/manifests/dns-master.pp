class dc_profile::dns-master {
  include dc_bind
  dc_bind::server::conf { '/etc/bind/named.conf':
    directory                 => '/var/cache/bind',
    listen_on_addr            => [ 'any' ],
    listen_on_v6_addr         => [ 'any' ],
    forwarders                => [ '8.8.8.8', '8.8.4.4' ],
    allow_query               => [ 'localnets' ],
    allow_recursion           => [ '10.0.1.0/24', '10.1.1.0/24', '10.1.10.0/24' ],
    zones                     => {
    'sal01.datacentred.co.uk' => [
      'type master',
      'file "/var/lib/bind/db.sal01.datacentred.co.uk"',
      'allow-update { key "foreman"; }'
    ]
    },
  }
}
