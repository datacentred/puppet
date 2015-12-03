# Class: dc_profile::ceph::mon
#
# Instantiates a ceph monitor node
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class dc_profile::ceph::mon {

  include ::ceph
  include ::dc_ceph::keybackup
  include ::dc_icinga::hostgroup_ceph_mon

  if $::collectd_ceph {
    include ::dc_collectd::agent::ceph
  }

  Class['ceph::mon'] ->
  Class['dc_ceph::keybackup']

  # Ensure our 10GbE interfaces are properly configured
  $ceph_public = 'p1p1'

  augeas { $ceph_public:
    context => '/files/etc/network/interfaces',
    changes => [
        "set auto[child::1 = '${ceph_public}']/1 ${ceph_public}",
        "set iface[. = '${ceph_public}'] ${ceph_public}",
        "set iface[. = '${ceph_public}']/family inet",
        "set iface[. = '${ceph_public}']/method dhcp",
        # Now set via DHCP
        "rm iface[. = '${ceph_public}']/pre-up '/sbin/ip link set ${ceph_public} mtu 9000'",
    ],
  }

}
