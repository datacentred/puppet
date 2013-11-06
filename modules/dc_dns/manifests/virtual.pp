class dc_dns::virtual {

  define dnszone ($soa,$soaip,$nameservers,$reverse) {
    dns::zone { "$title":
      soa         => $soa,
      soaip       => $soaip,
      nameservers => $nameservers,
      reverse     => $reverse,
    }
  }
}
