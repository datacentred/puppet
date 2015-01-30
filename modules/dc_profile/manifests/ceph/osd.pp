# Class: dc_profile::ceph::osd
#
# Instantiates a ceph osd node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::ceph::osd {

  include ::dc_ceph::osd
  include ::dc_ceph::osd_sysctl
  include ::ceph::osd
  include ::dc_icinga::hostgroup_ceph_osd

  # Proprietary additions first to partition the
  # journal SSDs
  Class['dc_ceph::osd'] ->
  Class['ceph::osd']


  # Ensure both 10GbE interfaces are properly configured
  $ceph_public = 'p1p1'
  $ceph_storage = 'p1p2'

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

  augeas { $ceph_storage:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${ceph_storage}']/1 ${ceph_storage}",
        "set iface[. = '${ceph_storage}'] ${ceph_storage}",
        "set iface[. = '${ceph_storage}']/family inet",
        "set iface[. = '${ceph_storage}']/method dhcp",
        "set iface[. = '${ceph_storage}']/pre-up '/sbin/ip link set ${ceph_storage} mtu 9000'",
    ],
  }

}
