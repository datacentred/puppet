# == Class: dc_profile::ceph::radosgw_lb
#
class dc_profile::ceph::radosgw_lb {

  include ::dc_ssl::storage
  include ::dc_ssl::haproxy
  include ::loadbalancer::certs
  include ::loadbalancer

  Class['dc_ssl::storage'] ->
  Class['dc_ssl::haproxy'] ->
  Class['loadbalancer::certs'] ->
  Class['loadbalancer']

  $domain      = 'storage.datacentred.io'
  # WARNING: ensure this A record is resolvable from the puppet master
  #          e.g. CloudFlare
  $myip        = get_ip_addr("${::hostname}.${domain}")
  $ceph_public = 'p1p1' # Internet facing
  $ceph_lb     = 'p1p2' # Internally facing

  augeas { $ceph_public :
      context => '/files/etc/network/interfaces',
      changes => [
          "set auto[child::1 = '${ceph_public}']/1 ${ceph_public}",
          "set iface[. = '${ceph_public}'] ${ceph_public}",
          "set iface[. = '${ceph_public}']/family inet",
          "set iface[. = '${ceph_public}']/method static",
          "set iface[. = '${ceph_public}']/address ${myip}",
          "set iface[. = '${ceph_public}']/netmask 255.255.255.248",
          "set iface[. = '${ceph_public}']/post-up 'ip route replace default via 185.43.218.17'",
          "set iface[. = '${ceph_public}']/post-down 'ip route replace default via 10.10.9.1'",
      ],
  }

  augeas { $ceph_lb:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${ceph_lb}']/1 ${ceph_lb}",
        "set iface[. = '${ceph_lb}'] ${ceph_lb}",
        "set iface[. = '${ceph_lb}']/family inet",
        "set iface[. = '${ceph_lb}']/method dhcp",
        "set iface[. = '${ceph_lb}']/post-up[1] 'ip route add 10.10.0.0/16 via 10.10.9.1'",
        "set iface[. = '${ceph_lb}']/post-up[2] 'ip route add 10.253.2.0/24 via 10.10.9.1'",
        "set iface[. = '${ceph_lb}']/post-down[1] 'ip route del 10.10.0.0/16 via 10.10.9.1'",
        "set iface[. = '${ceph_lb}']/post-down[2] 'ip route del 10.253.2.0/24 via 10.10.9.1'",
    ],
  }

}
