# == Class: dc_profile::ceph::radosgw
#
# Profile for deployment of a rados gateway
#
class dc_profile::ceph::radosgw {

  include ::dc_icinga::hostgroup_ceph_rgw

  contain ::ceph::radosgw
  contain ::loadbalancer::members

  # Ensure both 10GbE interfaces are properly configured
  $ceph_lb = 'p1p1'
  $ceph_public = 'p1p2'

  augeas { $ceph_lb:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${ceph_lb}']/1 ${ceph_lb}",
        "set iface[. = '${ceph_lb}'] ${ceph_lb}",
        "set iface[. = '${ceph_lb}']/family inet",
        "set iface[. = '${ceph_lb}']/method dhcp",
        "set iface[. = '${ceph_lb}']/pre-up '/sbin/ip link set ${ceph_lb} mtu 9000'",
    ],
  }

  augeas { $ceph_public:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${ceph_public}']/1 ${ceph_public}",
        "set iface[. = '${ceph_public}'] ${ceph_public}",
        "set iface[. = '${ceph_public}']/family inet",
        "set iface[. = '${ceph_public}']/method dhcp",
        "set iface[. = '${ceph_public}']/pre-up '/sbin/ip link set ${ceph_public} mtu 9000'",
    ],
  }

}
