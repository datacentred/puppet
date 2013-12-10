class dc_dhcpdpools::virtual {

  define dhcpdpool ($network,$mask,$range,$gateway,$pxeserver="",$pxefilename="") {

    if $pxeserver != "" and $pxefilename != "" {
      dhcp::pool { "$title":
        network    => $network,
        mask       => $mask,
        range      => $range,
        gateway    => $gateway,
        nextserver => $pxeserver,
        pxefile    => $pxefilename,
      }
    }
    else {
      dhcp::pool { "$title":
        network    => $network,
        mask       => $mask,
        range      => $range,
        gateway    => $gateway,
      }
    }
  }
}

