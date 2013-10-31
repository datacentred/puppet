class dc_profile::dns_slave {

  include dns

  dns::zone {'sal01.datacentred.co.uk':
    zonetype => 'slave',
    masters => hiera(dnsmasters),
  }

  dns::zone {'5.1.10.in-addr.arpa':
    zonetype => 'slave',
    masters  => hiera(dnsmasters),
  }

}
