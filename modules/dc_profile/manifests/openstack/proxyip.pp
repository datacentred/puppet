# Class: dc_profile::openstack::proxyip
#
# Takes care of handling the necessary multi-homed
# network configuration on the API proxies
#
# Parameters:
#
# Actions:
#
# Requires: augeas
#
# Sample Usage:
#
class dc_profile::openstack::proxyip {

  $int_if   = 'eth0'
  $ext_if   = 'eth1'
  $domain   = 'datacentred.io'

  # Externally facing interface has a statically-assigned IP address
  # which we obtain from DNS.  You need to ensure that this interface
  # is already configured in Foreman in order for the necessary RR
  # to exist.
  $ip       = get_ip_addr("${::hostname}.${domain}")

  augeas { $int_if:
      context => '/files/etc/network/interfaces',
      changes => [
          "set auto[child::1 = '${int_if}']/1 ${int_if}",
          "set iface[. = '${int_if}'] ${int_if}",
          "set iface[. = '${int_if}']/family inet",
          "set iface[. = '${int_if}']/method dhcp",
          "set iface[. = '${int_if}']/post-up[1] 'ip route add 10.10.0.0/16 via 10.10.160.1'",
          "set iface[. = '${int_if}']/post-up[2] 'ip route add 10.253.2.0/24 via 10.10.160.1'",
          "set iface[. = '${int_if}']/post-down[1] 'ip route del 10.10.0.0/16 via 10.10.160.254'",
          "set iface[. = '${int_if}']/post-down[2] 'ip route del 10.10.0.0/16 via 10.10.160.254'",
      ],
  }

  augeas { $ext_if :
      context => '/files/etc/network/interfaces',
      changes => [
          "set auto[child::1 = '${ext_if}']/1 ${ext_if}",
          "set iface[. = '${ext_if}'] ${ext_if}",
          "set iface[. = '${ext_if}']/family inet",
          "set iface[. = '${ext_if}']/method static",
          "set iface[. = '${ext_if}']/address ${ip}",
          "set iface[. = '${ext_if}']/netmask 255.255.255.248",
          "set iface[. = '${ext_if}']/post-up[1] 'ip route replace default via 185.43.218.25'",
          "set iface[. = '${ext_if}']/post-down[1] 'ip route replace default via 10.10.160.1'",
      ],
  }

}
