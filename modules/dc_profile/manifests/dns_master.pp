class dc_profile::dns_master {

  include dns

  dns::zone { 'sal01.datacentred.co.uk':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    nameservers => hiera(nameservers),
  }

  dns::zone {'5.1.10.in-addr.arpa':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    reverse     => true,
    nameservers => hiera(nameservers),
  }

  dns::zone {'192.10.10.in-addr.arpa':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    reverse     => true,
    nameservers => hiera(nameservers),
  }

}
