class dc_dns::virtual {


  define dnszone ($soa,$soaip,$nameservers,$reverse,$isslave = false) {
    if $isslave {
      dns::zone {"$title":
        zonetype    => 'slave',
        masters     => hiera(dnsmasters),
        nameservers => $nameservers
      }
    }
    else {
      dns::zone {"$title":
        soa         => $soa,
        soaip       => $soaip,
        nameservers => $nameservers,
        reverse     => $reverse,
      }
    }
  }
}
