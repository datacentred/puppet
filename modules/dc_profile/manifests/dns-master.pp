class dc_profile::dns-master {

  include dns

  dns::zone { 'sal01.datacentred.co.uk':
    soa     => "$fqdn",
    soaip   => "$ipaddress_eth0",
    ttl     => '10800',
    refresh => '86400',
  }

}
