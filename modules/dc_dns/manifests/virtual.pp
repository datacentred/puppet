class dc_dns::virtual {

  include dns

  define dnszone ($soa,$soaip,$nameservers,$reverse,$zonetype,$masters = '') {
    dns::zone {"$title":
      soa         => $soa,
      soaip       => $soaip,
      nameservers => $nameservers,
      reverse     => $reverse,
      zonetype    => $zonetype,
      masters     => $masters
    }
  }
}
