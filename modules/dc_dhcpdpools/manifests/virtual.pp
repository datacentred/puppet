class dc_dhcpdpools::virtual {

  include stdlib

  define dhcpdpool ($network,$mask,$range,$gateway,$pxeserver="",$pxefilename="",$options="") {

      dhcp::pool { "$title":
        network    => $network,
        mask       => $mask,
        range      => $range,
        gateway    => $gateway,
        nextserver => $pxeserver,
        pxefile    => $pxefilename,
        options    => $options,
      }
  }
}

