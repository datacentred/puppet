class dc_dns::dnszone {

  include dc_dns::virtual

  $nameservers = hiera(nameservers)

  # SAL01 top level

  @dc_dns::virtual::dnszone { 'sal01.datacentred.co.uk':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    nameservers => $nameservers,
    reverse     => false,
    tag         => sal01
  }

  # Reverse for 10.10.192

  @dc_dns::virtual::dnszone { '192.10.10.in-addr.arpa':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    nameservers => $nameservers,
    reverse     => true,
    tag         => '10.10.192'
  }

  @dc_dns::virtual::dnszone { '193.10.10.in-addr.arpa':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    nameservers => $nameservers,
    reverse     => true,
    tag         => '10.10.193'
  }
  @dc_dns::virtual::dnszone { '5.1.10.in-addr.arpa':
    soa         => "$fqdn",
    soaip       => "$ipaddress",
    nameservers => $nameservers,
    reverse     => true,
    tag         => '10.1.5'
  }
}
