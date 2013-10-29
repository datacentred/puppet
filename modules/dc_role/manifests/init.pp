class dc_role::generic {
  include dc_profile::base
}

class dc_role::cephnode inherits dc_role::generic {
  include dc_profile::cephnode
}

class dc_role::os-controller inherits dc_role::generic {
  include dc_profile::openstack-controller
}

class dc_role::os-network-controller inherits dc_role::generic {
  include dc_profile::os-network-controlller
}

class dc_role::os-compute inherits dc_role::generic {
  include dc_profile::os-compute
}

class dc_role::dns_master inherits dc_role::generic {
  include dc_profile::dns_master
}

class dc_role::dns_slave inherits dc_role::generic {
  include dc_profile::dns_slave
}
