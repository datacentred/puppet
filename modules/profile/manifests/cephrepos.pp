class profile::cephrepos {

# FIXME this should handle multiple versions
# do something like check if Ceph is already installed
# and then install the appropriate repo

	realize (Repos::Virtual::Repo['ceph_cuttlefish_mirror'])

}	
