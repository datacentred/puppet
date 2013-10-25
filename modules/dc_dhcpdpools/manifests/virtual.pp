class dc_dhcpdpools::virtual {
  define dhcpdpool ($network,$mask,$range,$gateway) {

    dhcp::pool { $title:
      network => "$network",
      mask    => "$mask",
      range   => "$range",
      gateway => "$gateway",
    }
  }
}
