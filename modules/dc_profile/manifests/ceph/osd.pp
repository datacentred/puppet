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

  include ::sysctls
  include ::dc_ceph::osd
  include ::ceph
  include ::dc_icinga::hostgroup_ceph_osd

  Class['::dc_ceph::osd'] -> Class['::ceph']

  # ***README***
  # This only caters for machines post reboot, OSD nodes need to generate the same
  # file during pre-seed so they come up initially with the correct rules in place
  # so if you modify this please do the same in Foreman
  file { '/etc/udev/rules.d/99-osd.rules':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'SUBSYSTEM=="block", ATTR{queue/rotational}=="1", ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/read_ahead_kb}="1024", ATTR{queue/nr_requests}="1024"',
  }

  $packages = [
    'sg3-utils',
    'lsscsi',
  ]

  ensure_packages($packages)

}
