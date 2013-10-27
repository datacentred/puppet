class dc_profile::dns-master {

  include dns

  dns::zone { 'sal01.datacentred.co.uk':
    soa     => "$fqdn",
    soaip   => "$ipaddress_eth0",
  }

  dns::zone {'5.1.10.in-addr.arpa':
    soa     => "$fqdn",
    soaip   => "$ipaddress_eth0",
    reverse => true,
  }

}
