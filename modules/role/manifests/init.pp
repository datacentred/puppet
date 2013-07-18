class role::generic {
	include profile::base
}

class role::dev inherits role::generic {
	include profile::dev
}

class role::os-controller inherits role::generic {
	include profile::openstack-controller
}

class role::os-network-controller inherits role::generic {
	include profile::os-network-controlller
}

class role::os-compute inherits role::generic
	include profile::os-compute
}
