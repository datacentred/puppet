# Class: dc_ceph::mon
#
# Instantiates a ceph monitor node
#
# Parameters:
#
# All the following are sourced from hiera
#
# $ceph_mon_key   - cluster monitor key
# $ceph_admin_key - administrator key
#
# Actions:
#
# Requires:
#
# dc_ceph - must be executed before dc_ceph::mon
#
# Sample Usage:
#
class dc_ceph::mon (
  $ceph_mon_key   = undef,
  $ceph_admin_key = undef,
) {

  # The community has spoken!  Don't mess up my modules
  # just allow them to execute anything in a random path!

  Exec {
    path => [ '/bin', '/usr/bin' ],
  }

  # By explicitly giving the monitor a keyring we can enable
  # access by the client.admin user as ceph::mon doesn't
  # do this itself, and probably wont
  #
  # TODO: We could probably wrap this in a keyring class
  # should the need arise rather than have a fixed template
  # the other option being an iterative template that accepts
  # a hash from hiera

  file { '/var/lib/ceph/mon/ceph.mon.keyring':
    content => template('dc_ceph/ceph.mon.keyring.erb'),
  } ->

  # TODO: Needs a public address defining if we are having
  # sepparate ethernet adaptors for each network

  ceph::mon { $::hostname:
    keyring => '/var/lib/ceph/mon/ceph.mon.keyring',
  }

  ceph::key { 'client.admin':
    secret  => $ceph_admin_key,
    cap_mon => 'allow *',
    cap_osd => 'allow *',
    cap_mds => 'allow',
  }

  # Export our details so they get propagated to all nodes
  # in the cluster

  exported_vars::set { 'ceph_mon_initial_members':
    value => $::hostname,
  }

  exported_vars::set { 'ceph_mon_host':
    value => $::ipaddress,
  }

}
