class dc_profile::cephrepos {

# FIXME this should handle multiple versions
# do something like check if Ceph is already installed
# and then install the appropriate repo

  realize (Dc_repos::Repo['ceph_c_mirror'])

}
