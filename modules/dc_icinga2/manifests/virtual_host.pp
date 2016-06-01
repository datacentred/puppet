# == Define: dc_icinga2::virtual_host
#
# Define a passive virtual host (e.g. PDU, VIP)
#
define dc_icinga2::virtual_host (
  $address,
  $vars,
  $icon_image,
) {

  $_tags = [ $::domain ]

  @@icinga2::object::endpoint { $title:
    tag => $_tags,
  }

  @@icinga2::object::zone { $title:
    endpoints => [
      $title,
    ],
    parent    => $::fqdn,
    tag       => $_tags,
  }

  @@icinga2::object::host { $title:
    import     => 'virtual-host',
    address    => $address,
    zone       => $::fqdn,
    vars       => $vars,
    icon_image => $icon_image,
    target     => "/etc/icinga2/zones.d/${title}/hosts.conf",
  }
}
