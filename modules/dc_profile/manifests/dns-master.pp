class dc_profile::dns-master {

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

}
