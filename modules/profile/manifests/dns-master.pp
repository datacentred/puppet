class profile::dns-master {

  $foremankey = hiera(foreman_secret_key)
  $clientnets = hiera(client_networks)

  include dc_bind

  dc_bind::server::conf { '/etc/bind/named.conf':
    directory                 => '/var/cache/bind',
    listen_on_addr            => [ 'any' ],
    listen_on_v6_addr         => [ 'any' ],
    forwarders                => [ '8.8.8.8', '8.8.4.4' ],
    allow_query               => [ 'any' ],
    allow_recursion           => [ 'clients'],
    acls                      => { clients => [ $clientnets ], },
    keys                      => { foreman => [ $foremankey ], },
    zones                     => {
    'sal01.datacentred.co.uk' => [
      'type master',
      'file "/var/lib/bind/db.sal01.datacentred.co.uk"',
      'allow-update { key "foreman"; }'
    ]
    },
  }
  dc_bind::server::file { 'db.sal01.datacentred.co.uk':
        source => 'puppet:///modules/dc_bind/db.sal01.datacentred.co.uk',
  }
  dc_bind::server::file { 'db.root':
        source => 'puppet:///modules/dc_bind/db.root',
  }
}
