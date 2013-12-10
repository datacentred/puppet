class dc_dhcpdpools::virtual {

  include stdlib

  define dhcpdpool ($network,$mask,$range,$gateway,$pxeserver="",$pxefilename="",$options="",$parameters="") {

      dhcp::pool { "$title":
        network    => $network,
        mask       => $mask,
        range      => $range,
        gateway    => $gateway,
        nextserver => $pxeserver,
        pxefile    => $pxefilename,
        options    => $options,
        parameters => $parameters,
      }
  }
}

